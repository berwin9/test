exports.index = (req, res) ->
  res.render 'index.jade', title: 'Express'

exports.loginGet = (req, res) ->
  res.render 'login.jade'

exports.loginPost = (req, res) ->

exports.logout  = (req, res) ->
  req.logout()
  res.redirect '/'

exports.register = (req, res) ->
  res.render 'register.jade'

exports.registerPost = (req, res) ->
  

exports.recoverPassword = (req, res) ->
  res.render 'recover_password.jade'
