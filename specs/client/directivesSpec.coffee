describe 'directive', ->

  beforeEach(module 'test')

  describe 'testMarkdown', ->

    it 'should create html out of markdown text', (inject ($rootScope, $compile) ->
      element = angular.element('<div data-test-markdown="#Test"></div>')
      element = $compile(element)($rootScope.$new())
      expect(angular.element(element).find('h1').length).toBe 1
    )
