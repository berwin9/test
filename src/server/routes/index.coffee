exports.index = (req, res) ->
  res.render 'index.jade', title: 'Express'

exports.login = (req, res) ->
  res.render 'login.jade'

exports.logout  = (req, res) ->
  req.logout()
  res.redirect '/'

exports.register = (req, res) ->
  res.render 'register.jade'

exports.recoverPassword = (req, res) ->
  res.render 'recover_password.jade'
