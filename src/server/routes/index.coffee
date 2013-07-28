class Notification
  constructor: (@type, @message) ->

notifications =
  noUserFound: new Notification(
    'alert-info',
    'The email you entered does not belong to any account. Please register to log in.'
  )
  badEmailOrPassword: new Notification(
    'alert-danger',
    'Bad Email or Password used on Log In Form.'
  )
  accountCreationFailed: new Notification(
    'alert-danger',
    'Account creation failed on Registration Form.'
  )

authenticate = (req, res, user) ->
  remember = req.body['login-remember']?
  req.session.userId = user.id
  if remember
    loginToken = new app.LoginTokenModel(email: user.email)
    loginToken.save ->
      console.log 'saverific'
      res.cookie 'loginToken', loginToken.cookieValue,
        expires: new Date(Date.now() + (2 * 604800000))
        path: '/'
  res.redirect '/'

badEmailOrPassword = (req, res) ->
  res.render 'login.jade',
    bootstrap:
      notifications: [notifications.badEmailOrPassword]

noUserFound = (req, res) ->
  res.render 'login.jade',
    bootstrap:
      notifications: [notifications.noUserFound]

accountCreationFailed = (req, res) ->
  res.render 'login.jade',
    bootstrap:
      notifications: [notifications.accountCreationFailed]


module.exports = (app) ->
  routes = {}

  routes.index = (req, res) ->
    res.render 'index.jade', title: title

  routes.loginGet = (req, res) ->
    res.render 'login.jade', title: title

  routes.loginPost = (req, res) ->
    email = req.body['login-email']
    password = req.body['login-password']

    app.UserModel.findOne email: email, (err, user) ->
      if user?
        if user.authenticate(password)
            authenticate(req, res, user)
        else badEmailOrPassword(req, res)
      else noUserFound(req, res)

  routes.logout = (req, res) ->
    req.logout()
    res.redirect '/'

  routes.register = (req, res) ->
    user = new app.UserModel(
      email: req.body['registration-email']
      password: req.body['registration-password']
    )
    user.save (err) ->
      throw err if err?
      authenticate(req, res, user)

  routes
