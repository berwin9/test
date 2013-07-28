express = require 'express'
engines = require 'consolidate'
mongoose = require 'mongoose'
mongoStore = require 'connect-mongodb'


app = express()
app.use express.logger()
models = require './models'
routes = require('./routes')(app)
helpers = require('./helpers')(app)
app.locals.title = 'Quizerfoo'

app.configure 'development', ->
  app.set 'db-uri', 'mongodb://localhost/db-dev'
  app.use express.errorHandler(dumpExceptions: true)
  app.set 'view options', pretty: true

app.configure 'production', ->
  app.set 'db-uri', 'mongodb://localhost/db-prod'


# configure the application
# keep in mind the order of registration matters for the middleware.
# we also use 2 view engine so we can use haml, but we can't use it fully
# because of some drawbacks/quirks in hamljs
app.engine 'jade', require('jade').__express
app.engine 'haml', engines.haml
app.set 'views', __dirname + '/views'
app.use express.favicon()
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.session
  cookie:
    maxAge: 60000 * 30
  store: new mongoStore(url: app.set 'db-uri')
  secret: 'super top secret pass'
app.use express.logger()
app.use express.methodOverride()
app.use app.router
app.use express.static(__dirname + '/public')


models.init mongoose, ->
  app.UserModel = mongoose.model 'UserModel'
  app.LoginTokenModel = mongoose.model 'LoginTokenModel'
  app.db = mongoose.connect app.set('db-uri')


app.get '/', helpers.checkUser, routes.index
app.get '/login', routes.loginGet
app.get '/logout', routes.logout
app.post '/login', routes.loginPost
app.post '/register', routes.register


port = process.env.PORT || 5000
app.listen port, -> console.log 'Listening on ' + port
