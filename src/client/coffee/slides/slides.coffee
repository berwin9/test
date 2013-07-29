angular.module('test')

  .controller 'SlideCtrl', ['$scope', 'QuizItemModelsService',
    ($scope, QuizItemModelsService) ->
      @quizItems = null
      @curActiveQuizIndex = null
      @curActiveQuizItemModel = null

      @setActiveModelByIndex = (index) =>
        @curActiveQuizItemModel = @quizItems[index] if @quizItems?

      @onSlideIndexClick = (index) =>
        @setActiveModelByIndex index

      QuizItemModelsService.get().then (models) =>
        @quizItems = models
        @curActiveQuizIndex = 0
        @setActiveModelByIndex @curActiveQuizIndex

      @getPossibleAnswersByIds = (ids) ->
        QuizItemModelsService.getAnswerModelsByIds ids if ids?

      # because of coffeescripts implied return at end, this causes bugs
      # when using angulars `controller as` syntax so we need to explicitly
      # return the controller instance
      @
  ]
