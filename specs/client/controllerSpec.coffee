describe 'controllers', ->

  beforeEach -> module 'test'

  describe 'SlideCtrl', ->
    slide = null
    methodSpy = null
    mockPromise = null
    quizItems = null
    quizAnswers = null
    $httpBackend = null
    $controller = null
    QuizItemModelsService = null

    beforeEach(inject (_$controller_, $rootScope, _QuizItemModelsService_, Models, _$httpBackend_) ->
      $httpBackend = _$httpBackend_
      $controller = _$controller_
      QuizItemModelsService = _QuizItemModelsService_
      $httpBackend.whenGET().respond fakePayload

      # this will do fow now until we can  refactor the QuizItemModelsService
      # to expose its functionality that builds the models
      quizItems = [
        new Models.QuizItemModel('1', '1?', 1)
        new Models.QuizItemModel('2', '2?', 2)
        new Models.QuizItemModel('3', '3?', 3)
      ]
      quizAnswers = [
        new Models.QuizItemAnswerModel(1, '1')
        new Models.QuizItemAnswerModel(1, '2')
        new Models.QuizItemAnswerModel(1, '3')
      ]
      quizItem.setPossibleAnswerIds([1, 2]) for quizItem in quizItems
      quizItem.setCorrectAnswerIds([index]) for quizItem, index in quizItems

      $httpBackend.expectGET().respond(fakePayload)

      methodSpy = spyOn(QuizItemModelsService, 'get')
        .andCallThrough(then: (cb) -> cb quizItems)
      scope = $rootScope.$new()
      slide = $controller(
        'SlideCtrl',
        {
          $scope: scope
          QuizItemModelsService: QuizItemModelsService
        }
      )
    )

    it 'should start at the intro page on startup', ->
      expect(slide.curPageTemplate).toBe slide.pageTemplates.intro

    it 'should call `get` on `QuizItemModelsService`', ->
      expect(methodSpy.callCount).toBe(1)

    it 'should assign `@quizItems` when `QuizItemModelsService` response is back', ->
      expect(slide.quizItems).toBe null
      $httpBackend.flush()
      expect(slide.quizItems).not.toBe null

    it 'should set the active model by index', ->
      expect(slide.curActiveQuizIndex).toBe null
      $httpBackend.flush()
      slide.setActiveModelByIndex 2
      expect(slide.curActiveQuizIndex).toBe 2
      expect(slide.curQuizItem.id).toBe quizItems[2].id
      expect(slide.curQuizItem.id).toBe slide.quizItems[2].id

    it 'should set the correct active model when clicking on the pagination', ->
      expect(slide.curActiveQuizIndex).toBe null
      $httpBackend.flush()
      slide.onSlideIndexClick 2
      expect(slide.curActiveQuizIndex).toBe 2
      expect(slide.curQuizItem.id).toBe quizItems[2].id
      expect(slide.curQuizItem.id).toBe slide.quizItems[2].id

    it 'should go to the next question when the next button is clicked', ->
      expect(slide.curActiveQuizIndex).toBe null
      $httpBackend.flush()
      slide.onNextIndexClick()
      expect(slide.curActiveQuizIndex).toBe 0
      expect(slide.curQuizItem.id).toBe quizItems[0].id
      expect(slide.curQuizItem.id).toBe slide.quizItems[0].id
      slide.onNextIndexClick()
      expect(slide.curActiveQuizIndex).toBe 1
      expect(slide.curQuizItem.id).toBe quizItems[1].id
      expect(slide.curQuizItem.id).toBe slide.quizItems[1].id

    it 'should go to the previous question when the next button is clicked', ->
      expect(slide.curActiveQuizIndex).toBe null
      $httpBackend.flush()
      slide.setActiveModelByIndex 2
      slide.onPrevIndexClick()
      expect(slide.curActiveQuizIndex).toBe 1
      expect(slide.curQuizItem.id).toBe quizItems[1].id
      expect(slide.curQuizItem.id).toBe slide.quizItems[1].id

    it 'should not go out of bounds of the arrays length when next is clicked', ->
      $httpBackend.flush()
      max = slide.quizItems.length - 1
      slide.setActiveModelByIndex max
      slide.onNextIndexClick()
      slide.onNextIndexClick()
      expect(slide.curActiveQuizIndex).toBe max
      expect(slide.curQuizItem.id).toBe quizItems[max].id
      slide.setActiveModelByIndex max

    it 'should not go out of bounds of the arrays length when prev is clicked', ->
      $httpBackend.flush()
      for item in [0..slide.quizItems.length + 1]
        slide.onPrevIndexClick()
        expect(slide.curActiveQuizIndex).toBe 0
        expect(slide.curQuizItem.id).toBe quizItems[0].id

    it 'should check if current index is the active index', ->
      $httpBackend.flush()
      slide.setActiveModelByIndex 2
      expect(slide.isActiveIndex 2).toBe true
      expect(slide.isActiveIndex 1).toBe false

    it 'should set the current answer for the model', ->
      $httpBackend.flush()
      slide.setActiveModelByIndex 1
      expect(slide.curQuizItem.userAnswerId).toBe null
      slide.setAnswer '1'
      expect(slide.curQuizItem.userAnswerId).toBe '1'

    it 'should check if the current answer is the valid one for this quiz model', ->
      $httpBackend.flush()
      slide.setActiveModelByIndex 1
      expect(slide.isValidAnswer(slide.quizItems[1], quizItems[1])).toBe true
      expect(slide.isValidAnswer(slide.quizItems[1], quizItems[2])).toBe false

    it 'should sum the correct answers', ->
      $httpBackend.flush()
      slide.setActiveModelByIndex 1
      slide.setAnswer '2'
      # we need to switch to results to trigger a validation run
      slide.setPageTemplate slide.pageTemplates.results
      expect(slide.sumCorrectAnswers()).toBe 1

    it 'should start quiz at model 0 when `initQuiz` is called', ->
      $httpBackend.flush()
      slide.setPageTemplate slide.pageTemplates.results
      slide.setActiveModelByIndex 2
      expect(slide.curActiveQuizIndex).toBe 2
      slide.initQuiz()
      expect(slide.curActiveQuizIndex).toBe 0

    describe 'template switch', ->

      beforeEach -> $httpBackend.flush()

      it 'should set the correct page template type', ->
        slide.setPageTemplate slide.pageTemplates.intro
        expect(slide.curPageTemplate).toBe slide.pageTemplates.intro
        slide.setPageTemplate slide.pageTemplates.results
        expect(slide.curPageTemplate).toBe slide.pageTemplates.results

      it 'should reset the quiz when template is switched to intro', ->
        slide.setActiveModelByIndex 1
        slide.setAnswer '1'
        expect(slide.curQuizItem.userAnswerId).toBe '1'
        slide.setPageTemplate slide.pageTemplates.intro
        expect(slide.quizItems[1].userAnswerId).toBe null

      it 'should validate models when user jumps to results', ->
        slide.setActiveModelByIndex 1
        slide.setAnswer '2'
        expect(slide.curQuizItem.isValid()).toBe false
        slide.setPageTemplate slide.pageTemplates.results
        expect(slide.curQuizItem.isValid()).toBe true

    it 'should retrieve the associated possible answer models for this current quiz model', ->
      $httpBackend.flush()
      results = slide.getPossibleAnswersByIds([1, 2])
      expect(results[0].id).toBe '1'
      expect(results[1].id).toBe '2'
