express = require 'express'
engines = require 'consolidate'
mongoose = require 'mongoose'
mongoStore = require 'connect-mongodb'


app = express()
app.use express.logger()
models = require './models'
routes = require('./routes')(app)
helpers = require('./helpers')(app)

# configure the application, the order of registration matters
# for the middleware
app.engine 'jade', require('jade').__express
app.engine 'haml', engines.haml
app.set 'views', __dirname + '/views'
app.use express.logger()
app.use express.cookieParser()
app.use express.bodyParser()
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
  app.set 'db-uri', 'mongodb://localhost/db-dev'
  app.use express.errorHandler(dumpExceptions: true)
  app.set 'view options', pretty: true

app.configure 'production', ->
  app.set 'db-uri', 'mongodb://localhost/db-prod'


models.init ->
  app.UserModel = mongoose.model 'UserModel'
  app.LoginTokenModel = mongoose.model 'LoginTokenModel'
  app.db = mongoose.connect app.set('db-uri')

app.get '/', helpers.checkUser, routes.index
app.get '/recover-password', routes.recoverPassword
app.get '/login', routes.loginGet
app.get '/logout', routes.logout
app.post '/login', routes.loginPost
app.post '/register', routes.register

port = process.env.PORT || 5000
app.listen port, -> console.log 'Listening on ' + port
