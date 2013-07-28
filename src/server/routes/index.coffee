routes = {}

class Notification
  constructor: (@type, @message) ->

module.exports = (app) ->
  routes.index = (req, res) ->
    res.render 'index.jade', title: 'Quizerfoo'

  routes.loginGet = (req, res) ->
    res.render 'login.jade', title: 'Quizerfoo'

  routes.loginPost = (req, res) ->
    app.UserModel.findOne
      email: req.body.email
      (err, user) ->
        console.log req.body.password, 'password here'
        if user? and user.authenticate(req.body.password)
          console.log 'good'
          req.session.userId = user.id

          if req.body.remember
            loginToken = new app.LoginTokenModel(email: user.email)
            loginToken.save ->
              res.cookie 'loginToken', loginToken.cookieValue,
                expires: new Date(Date.now() + (2 * 604800000))
                path: '/'
          res.redirect '/'
        else
          console.log 'bad'
          res.render 'login.jade',
            bootstrap:
              notifications: [
                new Notification('alert-danger', 'Bad Email or Password.')
              ]

  routes.logout = (req, res) ->
    req.logout()
    res.redirect '/'

  routes.register = (req, res) ->
    user = new app.UserModel(
      email: req.body.email
      password: req.body.password
    )
    user.save (err) ->
      if err
        console.log 'errrrr hereererererere'
        res.render 'login.jade',
          bootstrap:
            notifications: [
              new Notification('alert-danger', 'Account creation failed.')
            ]
      req.session.userId = user.id
      res.redirect '/'

  routes.recoverPassword = (req, res) ->
    res.render 'recover_password.jade'

  routes
