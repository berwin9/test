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


# keep in mind the order of registration matters for the middleware.
# we also use 2 view engines so we can use haml(besides jade), but we can't use it fully
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


# we need to pass in mongoose since the models actually
# need to register themselves to mongoose then we can assign and use
# them in `app`
models.init mongoose, ->
  app.UserModel = mongoose.model 'UserModel'
  app.LoginTokenModel = mongoose.model 'LoginTokenModel'
  app.db = mongoose.connect app.set('db-uri')


app.get '/', helpers.checkUser, routes.index
app.get '/login', routes.loginGet
app.get '/logout', routes.logout
app.post '/login', routes.loginPost
app.post '/register', routes.register


app.get '/404', (req, res) ->
  throw new Error('An expected error')

app.get '/500', (req, res) ->
  throw new Error('An expected error')


port = process.env.PORT || 5000
app.listen port, -> console.log 'Listening on ' + port
