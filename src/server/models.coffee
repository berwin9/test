crypto = require 'crypto'

validatePresenseOf = (value) ->
  value? and !!value.length

exports.init = (mongoose, cb) ->
  Schema = mongoose.Schema

  UserModel = new Schema
    email:
      type: String
      validate: [validatePresenseOf, 'an email is required']
      index:
        unique: true
    hashedPassword: String
    salt: String
    created_date: Date
    updated_date: Date

  UserModel.virtual('id')
    .get -> @_id.toHexString()

  UserModel.virtual('password')
    .set (password) ->
      @_password = password
      @salt = @makeSalt()
      @hashedPassword = @encryptPassword(password)
    .get -> @_password

  UserModel.method 'authenticate', (plainText) ->
    @encryptPassword(plainText) is @hashedPassword

# simple salt, since we dont need anything robust right now for the demo
  UserModel.method 'makeSalt', ->
    '' + Math.round(new Date().valueOf() * Math.random())

  UserModel.method 'encryptPassword', (password) ->
    crypto.createHmac('sha1', @salt).update(password).digest('hex')

  UserModel.method 'isPasswordPresent', ->
    validatePresenseOf @password

  UserModel.pre 'save', (next) ->
    if @isPasswordPresent()
      @created_date = new Date() if not @created_date
      @updated_date = new Date()
      next()
    else
      next new Error('Invalid password')


  LoginTokenModel = new Schema
    email:
      type: String
      index: true
    series:
      type: String
      index: true
    token:
      type: String
      index: true

  LoginTokenModel.method 'randomToken', ->
    '' + Math.round(new Date().valueOf() * Math.random())

  LoginTokenModel.pre 'save', (next) ->
    @token = @randomToken()
    @series = @randomToken() if @isNew
    next()

  LoginTokenModel.virtual('id')
    .get -> @_id.toHexString()

  LoginTokenModel.virtual('cookieValue')
    .get ->
      JSON.stringify
        email: @email
        token: @token
        series: @series


  QuizItemAnswersModel = new Schema
    anwser:
      type: String

  QuizItemAnswersModel.virtual('id')
    .get -> @_id.toHexString()

  QuizItemAnswersModel.pre 'save', (next) ->
    if next then next()


  QuizItemModel = new Schema
    order_number:
      type: Number
      index: true
      unique: true
    question:
      type: String
    correct_answers: [QuizItemAnswersModel]
    possible_answers: [QuizItemAnswersModel]


  QuizItemModel.virtual('id')
    .get -> @_id.toHexString()

  QuizItemModel.pre 'save', (next) ->
    if next then next()

  mongoose.model 'UserModel', UserModel
  mongoose.model 'LoginTokenModel', LoginTokenModel
  mongoose.model 'QuizItemAnswersModel', QuizItemAnswersModel
  mongoose.model 'QuizItemModel', QuizItemModel
  cb()
