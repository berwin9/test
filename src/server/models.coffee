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
    createdDate: Date
    updatedDate: Date

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
      @createdDate = new Date() if not @createdDate
      @updatedDate = new Date()
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


  QuizItemAnswerModel = new Schema
    anwser:
      type: String
      validate: [validatePresenseOf, 'an answer is required']
      index:
        unique: true
    createdDate: Date
    updatedDate: Date

  QuizItemAnswerModel.virtual('id')
    .get -> @_id.toHexString()

  QuizItemAnswerModel.pre 'save', (next) ->
    @createdDate = new Date() if not @createdDate
    @updatedDate = new Date()
    next()


  QuizItemModel = new Schema
    orderNumber:
      type: Number
      index:
        unique: true
    question:
      type: String
      validate: [validatePresenseOf, 'a question is required']
    correctAnswers: [QuizItemAnswerModel]
    possibleAnswers: [QuizItemAnswerModel]
    createdDate: Date
    updatedDate: Date


  QuizItemModel.virtual('id')
    .get -> @_id.toHexString()

  QuizItemModel.pre 'save', (next) ->
    @createdDate = new Date() if not @createdDate
    @updatedDate = new Date()
    next()

  mongoose.model 'UserModel', UserModel
  mongoose.model 'LoginTokenModel', LoginTokenModel
  mongoose.model 'QuizItemAnswerModel', QuizItemAnswerModel
  mongoose.model 'QuizItemModel', QuizItemModel
  cb()
