express = require("express")
app = express()
app.use express.logger()

port = process.env.PORT || 5000

app.use express.static(__dirname)

app.listen port, -> console.log "Listening on " + port
