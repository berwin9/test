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


    it 'should set the correct active model when clicking on the pagination', ->
      expect(slide.curActiveQuizIndex).toBe null
      $httpBackend.flush()
      slide.onSlideIndexClick 2
      expect(slide.curActiveQuizIndex).toBe 2
      expect(slide.curQuizItem.id).toBe quizItems[2].id

    it 'should go to the next question when the next button is clicked', ->
      expect(slide.curActiveQuizIndex).toBe null
      $httpBackend.flush()
      slide.onNextIndexClick()
      expect(slide.curActiveQuizIndex).toBe 0
      expect(slide.curQuizItem.id).toBe quizItems[0].id
      slide.onNextIndexClick()
      expect(slide.curActiveQuizIndex).toBe 1
      expect(slide.curQuizItem.id).toBe quizItems[1].id

    it 'should go to the previous question when the next button is clicked', ->
      expect(slide.curActiveQuizIndex).toBe null
      $httpBackend.flush()
      slide.setActiveModelByIndex 2
      slide.onPrevIndexClick()
      expect(slide.curActiveQuizIndex).toBe 1
      expect(slide.curQuizItem.id).toBe quizItems[1].id

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
