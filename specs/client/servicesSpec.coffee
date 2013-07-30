describe 'services', ->

  beforeEach(module 'test')

  describe 'questions url', ->

    it 'should be /questions', (inject (quizItemModelsUrl) ->
      expect(quizItemModelsUrl).toBe '/questions'
    )

  describe 'QuizItemModelsService', ->
    $httpBackend = null
    QuizItemModelsService = null

    beforeEach(inject (_$httpBackend_, _QuizItemModelsService_) ->
      $httpBackend = _$httpBackend_
      QuizItemModelsService = _QuizItemModelsService_
      $httpBackend.whenGET().respond fakePayload
      QuizItemModelsService.get()
    )

    it 'should build `n` number of quiz models equal to payload', ->
      cache = QuizItemModelsService.getQuizItemModelsCache()
      cacheLength = 0
      ++cacheLength for own key, value of cache
      expect(cacheLength).toBe 0
      $httpBackend.flush()
      cache = QuizItemModelsService.getQuizItemModelsCache()
      ++cacheLength for own key, value of cache
      expect(cacheLength).toBe fakePayload.length

    it 'should build `n` number of answer models equal to payload', ->
      cache = QuizItemModelsService.getQuizAnswerModelsCache()
      cacheLength = 0
      ++cacheLength for own key, value of cache
      expect(cacheLength).toBe 0
      $httpBackend.flush()
      cache = QuizItemModelsService.getQuizAnswerModelsCache()
      ++cacheLength for own key, value of cache
      expect(cacheLength).toBe 3

    it 'should build the quiz models', ->
      $httpBackend.flush()
      cache = QuizItemModelsService.getQuizItemModelsCache()
      cacheItem = cache['1']
      expect(cacheItem).not.toBe null
      expect(cacheItem.id).toBe '1'
      expect(cacheItem.question).toBe '1?'
      expect(cacheItem.orderNumber).toBe 1

    it 'should build the answer models', ->
      $httpBackend.flush()
      cache = QuizItemModelsService.getQuizAnswerModelsCache()
      cacheItem = cache['1']
      expect(cacheItem).not.toBe null
      expect(cacheItem.id).toBe '1'
      expect(cacheItem.answer).toBe '1'

  describe 'Models', ->
    cache = null

    beforeEach(inject (_$httpBackend_, _QuizItemModelsService_) ->
      $httpBackend = _$httpBackend_
      QuizItemModelsService = _QuizItemModelsService_
      $httpBackend.whenGET().respond fakePayload
      QuizItemModelsService.get()
      $httpBackend.flush()
      cache = QuizItemModelsService.getQuizItemModelsCache()
    )

    it 'should validate if the answer is correct', ->
      expect(cache['1'].isValidAnswer('1')).toBe true
      expect(cache['1'].isValidAnswer('2')).not.toBe true
      expect(cache['2'].isValidAnswer('2')).toBe true
      expect(cache['2'].isValidAnswer('1')).not.toBe true
