express = require 'express'
routes = require './routes'
engines = require 'consolidate'
mongoose = require 'mongoose'
mongoStore = require 'connect-mongodb'

models = require './models'

app = express()
app.use express.logger()

UserModel = null
LoginTokenModel = null
db = null

checkUser = (req, res, next) ->
  if req.session.user_id
    UserModel.findById req.session.user_id, (err, user) ->
      if user
        req.currentUser = user
        next()
      else
        res.redirect '/login'
  else if req.cookies.logintoken
    authenticateFromLoginToken req, res, next
  else
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
  UserModel = mongoose.model 'UserModel'
  LoginTokenModel = mongoose.model 'LoginTokenModel'
  db = mongoose.connect app.set('db-uri')

app.get '/', checkUser, routes.index
app.get '/register', routes.register
app.get '/recover-password', routes.recoverPassword
app.get '/login', routes.loginGet
app.get '/logout', routes.logout
app.post '/login', routes.loginPost

port = process.env.PORT || 5000
app.listen port, -> console.log 'Listening on ' + port
