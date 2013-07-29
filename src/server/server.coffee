express = require 'express'
mongoose = require 'mongoose'
mongo = require 'mongodb'
url = require 'url'


class App
  constructor: ->
    @express = @models = @routes = @helpers = null

  init: ->
    @express = app = express()
    @models = require './models'
    @routes = require('./routes')(app)
    @helpers = require('./helpers')(app)
    @questions = require('./questions')(app)
    app.locals.title = 'Quizerfoo'

    app.configure 'development', ->
      app.set 'db-uri', 'mongodb://localhost/db-dev'
      app.use express.errorHandler(dumpExceptions: true)
      app.set 'view options', pretty: true

    app.configure 'production', ->
      app.set 'db-uri', process.env.MONGOLAB_URI

    connectionUri = url.parse app.set('db-uri')
    dbName = connectionUri.pathname.replace(/^\//, '')
    mongoStore = mongo.Db.connect app.set('db-uri'), (err, db) ->

    # keep in mind the order of registration matters for the middleware.
    # we also use 2 view engines so we can use haml(besides jade), but we can't use it fully
    # because of some drawbacks/quirks in hamljs
    app.engine 'jade', require('jade').__express
    app.set 'views', __dirname + '/views'
    app.use express.logger()
    app.use express.favicon()
    app.use express.bodyParser()
    app.use express.cookieParser()
    app.use express.session
      cookie:
        maxAge: 60000 * 30
      store: mongoStore
      secret: 'super top secret pass'
    app.use express.logger()
    app.use express.methodOverride()
    app.use app.router
    app.use express.static(__dirname + '/public')
    app.use @helpers.simpleErrorHandler

    @initDb app, @models, mongoose
    @initRoutes app, @routes, @helpers

  initRoutes: (app, routes, helpers) ->
    app.get '/', helpers.loadUser, routes.index
    app.get '/login', routes.loginGet
    app.get '/logout', helpers.loadUser, routes.logout
    app.post '/login', routes.loginPost
    app.post '/register', routes.register
    app.get '/500', helpers.throwError
    app.get '/:others', helpers.throwError

  initDb: (app, models, mongoose) ->
    # we need to pass in mongoose since the models actually
    # need to register themselves to mongoose then we can assign and use
    # them in `app`
    models.init mongoose, ->
      app.UserModel = mongoose.model 'UserModel'
      app.LoginTokenModel = mongoose.model 'LoginTokenModel'
      app.QuizItemAnswersModel = mongoose.model 'QuizItemAnswersModel'
      app.QuizItemModel = mongoose.model 'QuizItemModel'
      app.db = mongoose.connect app.set('db-uri')


app = new App()
app.init()

port = process.env.PORT || 5000
app.express.listen port, -> console.log 'Listening on ' + port

module.exports = App
