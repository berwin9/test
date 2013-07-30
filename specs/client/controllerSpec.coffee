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
        new Models.QuizItemModel(1, 'what is your item model number?', 1)
        new Models.QuizItemModel(2, 'what is your item model number?', 2)
      ]
      quizAnswers = [
        new Models.QuizItemAnswerModel(1, '1')
        new Models.QuizItemAnswerModel(1, '2')
      ]
      quizItem.setPossibleAnswerIds([1, 2]) for quizItem in quizItems
      quizItem.setCorrectAnswerIds([index]) for quizItem, index in quizItems

      $httpBackend.expectGET().respond(fakePayload)

      methodSpy = spyOn(QuizItemModelsService, 'get').andCallThrough()
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

    it 'should go to the first item', ->
      expect(slide.curActiveQuizIndex).toBe null

