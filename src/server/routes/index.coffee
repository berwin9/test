haml = require 'hamljs'
parse = require('url').parse
join = require('path').join
fs = require 'fs'
templateRoot = __dirname.replace(/routes$/, 'public')

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

module.exports = (app) ->
  routes = {}

  authenticate = (req, res, user) ->
    remember = req.body['login-remember']?
    req.session.userId = user.id
    if remember
      loginToken = new app.LoginTokenModel(email: user.email)
      loginToken.save ->
        # 2 week expiration for the loginToken
        res.cookie 'loginToken', loginToken.cookieValue,
          expires: new Date(Date.now() + (2 * 604800000))
          path: '/'
        res.redirect '/'
    else
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

  routes.index = (req, res) ->
    res.render 'index.jade'

  routes.loginGet = (req, res) ->
    res.render 'login.jade'

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
    if req.session?
      app.LoginTokenModel.remove email: req.currentUser.email, ->
      res.clearCookie 'loginToken'
      req.session.destroy ->
    res.redirect '/login'

  routes.register = (req, res) ->
    user = new app.UserModel
      email: req.body['registration-email']
      password: req.body['registration-password']
    user.save (err) ->
      if err? then return accountCreationFailed req, res
      authenticate(req, res, user)

  routes.hamlRouter = (req, res) ->
    url = parse req.url
    path = join templateRoot, url.pathname
    fs.readFile path, (err, data) ->
      if err?
        res.redirect '/500'
      else
        try
          html = haml.render data.toString()
          console.log html
          res.writeHead 200,
              'Content-Type': 'text/html',
              'Content-Length': Buffer.byteLength html
          res.end html
        catch
          res.redirect '/500'

  routes
