title = 'Quizerfoo'

class Notification
  constructor: (@type, @message) ->

notifications =
  badEmailOrPassword: new Notification('alert-danger', 'Bad Email or Password used on Login Form.')
  accountCreationFailed: new Notification('alert-danger', 'Account creation failed on Registration Form.')

module.exports = (app) ->
  routes = {}

  routes.index = (req, res) ->
    res.render 'index.jade', title: title

  routes.loginGet = (req, res) ->
    res.render 'login.jade', title: title

  routes.loginPost = (req, res) ->
    email = req.body['login-email']
    password = req.body['login-password']
    remember = req.body['login-remember']
    console.log 'remember me?', remember

    app.UserModel.findOne email: email, (err, user) ->
      if user? and user.authenticate(password)
        req.session.userId = user.id
        if remember
          loginToken = new app.LoginTokenModel(email: user.email)
          loginToken.save ->
            res.cookie 'loginToken', loginToken.cookieValue,
              expires: new Date(Date.now() + (2 * 604800000))
              path: '/'
        res.redirect '/'
      else
        res.render 'login.jade',
          title: title
          bootstrap:
            notifications: [notifications.badEmailOrPassword]

  routes.logout = (req, res) ->
    req.logout()
    res.redirect '/'

  routes.register = (req, res) ->
    user = new app.UserModel(
      email: req.body['registration-email']
      password: req.body['registration-password']
    )
    user.save (err) ->
      if err
        res.render 'login.jade',
          bootstrap:
            title: title
            notifications: [notifications.accountCreationFailed]
      req.session.userId = user.id
      res.redirect '/'

  routes.recoverPassword = (req, res) ->
    res.render 'recover_password.jade'

  routes
