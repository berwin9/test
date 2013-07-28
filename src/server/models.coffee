crypto = require 'crypto'
mongoose = require 'mongoose'
Schema = mongoose.Schema

validatePresenseOf = (value) ->
  value? and !!value.length

UserModel = new Schema
  email:
    type: String
    validate: [validatePresenseOf, 'an email is required']
    index:
      unique: true
  hashedPassword: String
  salt: String

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

#QuestionModel:

exports.init = (cb) ->
  mongoose.model 'UserModel', UserModel
  mongoose.model 'LoginTokenModel', LoginTokenModel
  cb()
