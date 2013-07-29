# decorator to initialize the SlideCtrl if its in a non quiz page
# (like the intro and results page) then this decorator will init it model 0
initQuizDecorator = (ctrl) ->
  (cb) ->
    ->
      console.log 'init quiz'
      unless ctrl.curActiveQuizIndex?
        ctrl.setSlideTemplate ctrl.pageTemplates.question
        ctrl.setActiveModelByIndex 0
      cb.apply(null, arguments)


angular.module('test')

  .controller 'SlideCtrl', ['$scope', 'QuizItemModelsService',
    ($scope, QuizItemModelsService) ->
      @pageTemplates =
        intro: 'intro.html'
        question: 'question.html'
        results: 'results.html'

      @curSlideTemplate = @pageTemplates.intro
      @quizItems = null
      @curActiveQuizIndex = null
      @curQuizItem = null

      @setActiveModelByIndex = (index) =>
        if @quizItems?
          @curQuizItem = @quizItems[index]
          @curActiveQuizIndex = index

      @onSlideIndexClick = initQuizDecorator(@) \
        (index) =>
          @setActiveModelByIndex index

      @onNextIndexClick = =>
        if not @curActiveQuizIndex?
          @setSlideTemplate @pageTemplates.questions
          @setActiveModelByIndex 0
        else if @curActiveQuizIndex isnt @quizItems.length - 1
          @setActiveModelByIndex(@curActiveQuizIndex + 1)

      @onPrevIndexClick = initQuizDecorator(@) \
        =>
          if @curActiveQuizIndex isnt 0
            @setActiveModelByIndex(@curActiveQuizIndex - 1)

      QuizItemModelsService.get().then (models) =>
        @quizItems = models

      @getPossibleAnswersByIds = (ids) ->
        QuizItemModelsService.getAnswerModelsByIds ids if ids?

      @setAnswer = (id) =>
        @curQuizItem.userAnswerId = id

      @resetQuiz = =>
        quizItem.resetAnswer() for quizItem in @quizItems

      @initQuiz = =>
        @curActiveQuizIndex = 0
        @setActiveModelByIndex @curActiveQuizIndex

      @setSlideTemplate = (template) =>
        @curSlideTemplate = template

      @isActiveIndex = (index) =>
        @curActiveQuizIndex is index

      # because of coffeescripts implied return at end, this causes bugs
      # when using angulars `controller as` syntax so we need to explicitly
      # return the controller instance
      @
  ]
