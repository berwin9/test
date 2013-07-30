angular.module('test')

  .value('quizItemModelsUrl', '/questions')

  .factory 'BootstrapService', ->
    get: ->
      window.__bootstrapData.notifications if window.__bootstrapData?

  .factory 'QuizItemModelsService', ['$http', 'quizItemModelsUrl', ($http, quizItemModelsUrl) ->
    _quizItemModelCache = {}
    _quizItemAnswersModelCache = {}

    get: ->
      $http.get(quizItemModelsUrl).then (response) ->
        quizItemModels = []
        for quizItem in response.data
          quizItemModel = new QuizItemModel(
            quizItem._id,
            quizItem.question,
            quizItem.orderNumber
          )
          possibleAnswerIds = []
          for answerItem in quizItem.possibleAnswers
            quizItemAnswerModel = new QuizItemAnswerModel(
              answerItem._id,
              answerItem.answer
            )
            possibleAnswerIds.push quizItemAnswerModel.id
            _quizItemAnswersModelCache[quizItemAnswerModel.id] = quizItemAnswerModel
          _quizItemModelCache[quizItemModel.id] = quizItemModel
          quizItemModel.setPossibleAnswerIds possibleAnswerIds
          quizItemModel.setCorrectAnswerIds(
            (correctAnswer._id for correctAnswer in quizItem.correctAnswers)
          )
          quizItemModels.push quizItemModel
        quizItemModels

    getAnswerModelsByIds: (ids) ->
      (_quizItemAnswersModelCache[id] for id in ids)
  ]


class QuizItemModel
  constructor: (@id, @question, @orderNumber) ->
    @possibleAnswerIds = null
    @correctAnswerIds = null
    @userAnswerId = null

  validate: ->

  isAnswered: -> @userQuizItemAnserModel?

  setPossibleAnswerIds: (arr) -> @possibleAnswerIds = arr

  setCorrectAnswerIds: (arr) -> @correctAnswerIds = arr

  setUserAnswerId: (id) -> @userAnswerId = id

  reset: -> @userAnswerId = null

  isValid: ->
    for correctAnswer in @correctAnswerIds \
    when correctAnswer is @userAnswerId
      return true
    return false

class QuizItemAnswerModel
  constructor: (@id, @answer) ->
