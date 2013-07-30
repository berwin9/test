angular.module('test')

  .value('quizItemModelsUrl', '/questions')

  .factory 'BootstrapService', ->
    get: ->
      window.__bootstrapData.notifications if window.__bootstrapData?

  .factory('QuizItemModelsService', ['$http', 'quizItemModelsUrl', 'Models',
    ($http, quizItemModelsUrl, Models) ->
      _quizItemModelCache = {}
      _quizItemAnswersModelCache = {}

      get: ->
        $http.get(quizItemModelsUrl).then (response) ->
          # TODO: break this up and make it accessible to be testable from the outside
          quizItemModels = []
          # build the models and cache them so we can just look it up later on
          for quizItem in response.data
            quizItemModel = new Models.QuizItemModel(
              quizItem._id,
              quizItem.question,
              quizItem.orderNumber
            )

            possibleAnswerIds = []
            for answerItem in quizItem.possibleAnswers
              quizItemAnswerModel = new Models.QuizItemAnswerModel(
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

      getQuizAnswerModelsCache: -> _quizItemAnswersModelCache

      getQuizItemModelsCache: -> _quizItemModelCache
  ])

  .factory('Models', ->
    class QuizItemModel

      constructor: (@id, @question, @orderNumber) ->
        @possibleAnswerIds = null
        @correctAnswerIds = null
        @userAnswerId = null
        @_isValid = false

      validate: -> @_isValid = @isValidAnswer @userAnswerId

      isAnswered: -> @userQuizItemAnserModel?

      setPossibleAnswerIds: (arr) -> @possibleAnswerIds = arr

      setCorrectAnswerIds: (arr) -> @correctAnswerIds = arr

      setUserAnswerId: (id) -> @userAnswerId = id

      reset: -> @userAnswerId = null

      isValid: -> @_isValid

      isValidAnswer: (answerId) ->
        for correctAnswer in @correctAnswerIds \
        when correctAnswer is answerId
          return true
        return false


    class QuizItemAnswerModel

      constructor: (@id, @answer) ->

    models =
      QuizItemAnswerModel: QuizItemAnswerModel
      QuizItemModel: QuizItemModel
  )
