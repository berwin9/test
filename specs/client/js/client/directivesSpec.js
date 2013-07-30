(function() {
  describe('directive', function() {
    beforeEach(module('test'));
    return describe('testMarkdown', function() {
      return it('should create html out of markdown text', inject(function($rootScope, $compile) {
        var element;
        element = angular.element('<div data-test-markdown="#Test"></div>');
        element = $compile(element)($rootScope.$new());
        return expect(angular.element(element).find('h1').length).toBe(1);
      }));
    });
  });

}).call(this);
