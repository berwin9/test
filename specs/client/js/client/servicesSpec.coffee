describe 'services', ->

  describe 'questions url', ->
    
    it 'should be /questions', (inject (quizItemModelsUrl) ->
      expect(quizItemModelsUrl).toBe '/questions'
    )

  describe 'QuizItemModelsService', ->

  describe 'Models', ->
