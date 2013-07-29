angular.module('test')

  .controller 'SlideCtrl', ['$scope', 'QuizItemModelsService',
    ($scope, QuizItemModelsService) ->
      @quizItems = null
      @curActiveQuizIndex = null
      @curQuizItem = null

      @setActiveModelByIndex = (index) =>
        if @quizItems?
          console.log index
          @curQuizItem = @quizItems[index]
          @curActiveQuizIndex = index

      @onSlideIndexClick = (index) =>
        @setActiveModelByIndex index

      @onNextIndexClick = =>
        if @curActiveQuizIndex isnt @quizItems.length - 1
          @setActiveModelByIndex(@curActiveQuizIndex + 1)

      @onPrevIndexClick = =>
        console.log @curActiveQuizIndex
        if @curActiveQuizIndex isnt 0
          @setActiveModelByIndex(@curActiveQuizIndex - 1)

      QuizItemModelsService.get().then (models) =>
        @quizItems = models
        @curActiveQuizIndex = 0
        @setActiveModelByIndex @curActiveQuizIndex

      @getPossibleAnswersByIds = (ids) ->
        QuizItemModelsService.getAnswerModelsByIds ids if ids?

      @setAnswer = (id) =>
        @curQuizItem.userAnswerId = id
      # because of coffeescripts implied return at end, this causes bugs
      # when using angulars `controller as` syntax so we need to explicitly
      # return the controller instance
      @
  ]
