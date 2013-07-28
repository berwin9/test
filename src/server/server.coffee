express = require 'express'
engines = require 'consolidate'
mongoose = require 'mongoose'
mongoStore = require 'connect-mongodb'


app = express()
app.use express.logger()
models = require './models'
routes = require('./routes')(app)

authenticateFromLoginToken = (req, res, next) ->
  cookie = JSON.parse req.cookies.loginToken
  app.LoginToken.findOne
      email: cookie.email
      series: cookie.series
      token: cookie.token
    (err, loginToken) ->
      if not loginToken?
        res.redirect '/login'
        return

      app.UserModel.findOne email: loginToken.email, (err, user) ->
        if user?
          req.session.userId = user.id
          req.currentUser = user
          loginToken.token = loginToken.randomToken()
          loginToken.save ->
            res.cookie 'loginToken', loginToken.cookieValue,
              expires: new Date(Date.now() + (2 * 604800000))
              path: '/'
            next()
        else
          res.redirect '/login'

checkUser = (req, res, next) ->
  if req.session.userId?
    console.log 'aaaa'
    app.UserModel.findById req.session.userId, (err, user) ->
      if user?
        console.log 'bbbbb'
        req.currentUser = user
        next()
      else
        console.log 'cccc'
        res.redirect '/login'
  else if req.cookies.loginToken
    console.log 'dddd'
    authenticateFromLoginToken req, res, next
  else
    console.log 'eeee'
    res.redirect '/login'

# configure the application, the order of registration matters
# for the middleware
app.engine 'jade', require('jade').__express
app.engine 'haml', engines.haml
app.set 'views', __dirname + '/views'
app.use express.logger()
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.session(secret: 'secret password')
app.use express.session(
  cookie:
    maxAge: 60000 * 30
  store: new mongoStore(app.set 'db-uri')
  secret: 'super secret password'
)
app.use express.methodOverride()
app.use app.router
app.use express.static(__dirname + '/public')

app.configure 'development', ->
  app.set 'db-uri', 'mongodb://localhost/db-development'
  app.use express.errorHandler(dumpExceptions: true)
  app.set 'view options', pretty: true

app.configure 'production', ->
  app.set 'db-uri', 'mongodb://localhost/db-production'


models.init ->
  app.UserModel = mongoose.model 'UserModel'
  app.LoginTokenModel = mongoose.model 'LoginTokenModel'
  app.db = mongoose.connect app.set('db-uri')

app.get '/', checkUser, routes.index
app.get '/recover-password', routes.recoverPassword
app.get '/login', routes.loginGet
app.get '/logout', routes.logout
app.post '/login', routes.loginPost
app.post '/register', routes.register

port = process.env.PORT || 5000
app.listen port, -> console.log 'Listening on ' + port
