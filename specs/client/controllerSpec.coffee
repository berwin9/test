describe 'controllers', ->

  beforeEach -> module 'test'

  describe 'SlideCtrl', ->
    slide = null
    methodSpy = null
    quizItems = null
    quizAnswers = null

    beforeEach(inject($controller, $rootScope, QuizItemModelsService, Models) ->
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

      scope = $rootScope.$new()
      spyOn(QuizItemModelsService, 'get').andReturn({
        then: (cb) -> cb quizItems
      })
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
