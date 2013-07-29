module.exports = (app) ->
  helpers = {}

  authenticateFromLoginToken = helpers.authenticateFromLoginToken = (req, res, next) ->
    cookie = JSON.parse req.cookies.loginToken
    app.LoginTokenModel.findOne(
        email: cookie.email
        series: cookie.series
        token: cookie.token,
      (err, loginToken) ->
        if not loginToken?
          res.redirect '/login'
          return

        app.UserModel.findOne email: loginToken.email, (err, user) ->
          if user?
            req.session.userId = user.id
            req.currentUser = user
            loginToken.token = loginToken.randomToken()
            loginToken.save ->
              res.cookie 'loginToken', loginToken.cookieValue,
                expires: new Date(Date.now() + (2 * 604800000))
                path: '/'
              next()
          else
            res.redirect '/login'
    )

  tryLoadUser = helpers.tryLoadUser = (req, res, next) ->
    if req.session.userId?
      app.UserModel.findById req.session.userId, (err, user) ->
        if user?
          req.currentUser = user
          next()
        else
          res.redirect '/login'
    else if req.cookies.loginToken
      authenticateFromLoginToken req, res, next
    else
      res.redirect '/login'

  simpleErrorHandler = helpers.simpleErrorHandler = (err, req, res, next) ->
    console.log err?.stack
    if err?.stack
      res.render '500.jade', status: 500

  throwError = helpers.throwError = ->
    throw new Error()

  helpers
