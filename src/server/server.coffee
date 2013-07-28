express = require 'express'
routes = require './routes'

app = express()
app.use express.logger()

port = process.env.PORT || 5000

app.set "views", __dirname + "/views"
app.set "view engine", "jade"
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.session(secret: "secret")
app.use express.methodOverride()
app.use app.router
app.use express.static(__dirname + "/public")

app.get '/', routes.index

app.listen port, -> console.log 'Listening on ' + port
