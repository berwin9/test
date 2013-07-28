express = require 'express'
routes = require './routes'
passport = require 'passport'
flash = require 'connect-flash'
engines = require 'consolidate'
LocalStrategy = require('passport-local').Strategy

users = [
  id: 1, username: 'erwin', password: 'password', email: 'win@example.com'
]

findById = (id, fn) ->
  idx = id - 1
  if users[idx]?
    fn null, users[idx]
  else
    fn new Error('User #{id} does not exist')

findByUsername = (username, fn) ->
  for user in users when user.username is username
    return fn null, user
  return fn null, null

ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated() then return next
  res.redirect '/login'

passport.serializeUser((user, done) -> done null, user.id)

passport.deserializeUser (id, done) ->
  findById(id, (err, user) -> done err, user)

passport.use new LocalStrategy(
  (username, password, done) ->
    process.nextTick ->
      findByUsername username, (err, usr) ->
        if err? then return done err
        if not user? then return done null, false, message: 'Unknown user #{username}'
        if user.password is not password then return done null, false, message: 'Invalid password'
        return done null, user
)



app = express()
app.use express.logger()

port = process.env.PORT || 5000

app.engine 'haml', engines.haml
app.set 'views', __dirname + '/views'
app.set 'view engine', 'haml'
app.use express.logger()
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.session(secret: 'secret password')
app.use flash()
app.use passport.initialize()
app.use passport.session()
app.use app.router
app.use express.static(__dirname + '/public')

app.get '/', routes.index
app.post('/login', passport.authenticate('local', { successRedirect: '/', failureRedirect: '/login', failureFlash: true }, (req, res) ->
  res.redirect '/'
))

app.get '/logut', (req, res) ->
  req.logout()
  res.redirect '/'


app.listen port, ->
  console.log 'Listening on ' + port
