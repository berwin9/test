# decorator to initialize the SlideCtrl if its in a non quiz page
# (like the intro and results page) then this decorator will init it model 0
initQuizDecorator = (ctrl) ->
  (cb) ->
    ->
      ctrl.initQuiz() unless ctrl.curActiveQuizIndex?
      cb.apply(null, arguments)


angular.module('test')

  .controller('SlideCtrl', ['$scope', 'QuizItemModelsService',
    ($scope, QuizItemModelsService) ->
      @pageTemplates =
        intro: 'intro.html'
        question: 'question.html'
        results: 'results.html'

      @curPageTemplate = @pageTemplates.intro
      @quizItems = null
      @curActiveQuizIndex = null
      @curQuizItem = null

      QuizItemModelsService.get().then (models) =>
        @quizItems = models

      @setActiveModelByIndex = (index) =>
        if @quizItems?
          @curActiveQuizIndex = index
          @curQuizItem = @quizItems[index]

      @onSlideIndexClick = initQuizDecorator(@) \
        (index) =>
          @setActiveModelByIndex index

      @onNextIndexClick = =>
        if not @curActiveQuizIndex?
          @setPageTemplate @pageTemplates.question
          @setActiveModelByIndex 0
        else if @curActiveQuizIndex isnt @quizItems.length - 1
          @setActiveModelByIndex(@curActiveQuizIndex + 1)

      @onPrevIndexClick = initQuizDecorator(@) \
        =>
          if @curActiveQuizIndex isnt 0
            @setActiveModelByIndex(@curActiveQuizIndex - 1)

      @getPossibleAnswersByIds = (ids) ->
        QuizItemModelsService.getAnswerModelsByIds ids if ids?

      @setAnswer = (id) => @curQuizItem.setUserAnswerId id

      @resetQuiz = => quizItem.reset() for quizItem in @quizItems

      @initQuiz = =>
        @curActiveQuizIndex = 0
        @setActiveModelByIndex @curActiveQuizIndex
        @setPageTemplate @pageTemplates.question

      @setPageTemplate = (template) =>
        @curPageTemplate = template
        switch template
          when @pageTemplates.intro then goToIntro()
          when @pageTemplates.results then goToResults()

      @isActiveIndex = (index) => @curActiveQuizIndex is index

      @sumCorrectAnswers = =>
        validAnswers = 0
        ++validAnswers for quizItem in @quizItems when quizItem.isValid()
        validAnswers

      @isValidAnswer = (quizModel, answerModel) =>
        quizModel.isValidAnswer(answerModel.id)

      goToIntro = => @resetQuiz()

      goToResults = => quizItem.validate() for quizItem in @quizItems

      # because of coffeescripts implied return at end, this causes bugs
      # when using angulars `controller as` syntax so we need to explicitly
      # return the controller instance
      @
  ])

  .controller('ResultsCtrl', ->
    showIndexes = {}

    @isHidden = (index) =>
      if showIndexes[index]?
        return not showIndexes[index]
      return not showIndexes[index] = false

    @toggleHide = (index) => showIndexes[index] = not showIndexes[index]

  )
