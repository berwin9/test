module.exports = (app) ->
  helpers = {}

  authenticateFromLoginToken = helpers.authenticateFromLoginToken = (req, res, next) ->
    cookie = JSON.parse req.cookies.loginToken
    console.log cookie, 'cookieeeee'
    console.log app.UserModel, 'helpers1'
    app.LoginTokenModel.findOne(
        email: cookie.email
        series: cookie.series
        token: cookie.token,
      (err, loginToken) ->
        if not loginToken?
          res.redirect '/login'
          return

        console.log app.UserModel, 'helpers'
        app.UserModel.findOne email: loginToken.email, (err, user) ->
          if user?
            req.session.userId = user.id
            req.currentUser = user
            loginToken.token = loginToken.randomToken()
            loginToken.save ->
              console.log 'saving token'
              res.cookie 'loginToken', loginToken.cookieValue,
                expires: new Date(Date.now() + (2 * 604800000))
                path: '/'
              next()
          else
            res.redirect '/login'
    )

  checkUser = helpers.checkUser = (req, res, next) ->
    if req.session.userId?
      console.log 'aaaa'
      app.UserModel.findById req.session.userId, (err, user) ->
        if user?
          console.log 'bbbbb'
          req.currentUser = user
          next()
        else
          console.log 'cccc'
          res.redirect '/login'
    else if req.cookies.loginToken
      console.log 'dddd'
      authenticateFromLoginToken req, res, next
    else
      console.log 'eeee'
      res.redirect '/login'

  helpers
