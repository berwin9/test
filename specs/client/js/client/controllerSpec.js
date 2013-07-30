(function() {
  describe('controllers', function() {
    var quizAnswers, quizItems;
    quizItems = null;
    quizAnswers = null;
    beforeEach(function() {
      module('test');
      return inject(function(Models) {
        var index, quizItem, _i, _j, _len, _len1, _results;
        quizItems = [new Models.QuizItemModel(1, 'what is your item model number?', 1), new Models.QuizItemModel(2, 'what is your item model number?', 2)];
        quizAnswers = [new Models.QuizItemAnswerModel(1, '1'), new Models.QuizItemAnswerModel(1, '2')];
        for (_i = 0, _len = quizItems.length; _i < _len; _i++) {
          quizItem = quizItems[_i];
          quizItem.setPossibleAnswerIds([1, 2]);
        }
        _results = [];
        for (index = _j = 0, _len1 = quizItems.length; _j < _len1; index = ++_j) {
          quizItem = quizItems[index];
          _results.push(quizItem.setCorrectAnswerIds([index]));
        }
        return _results;
      });
    });
    return describe('SlideCtrl', function() {
      var methodSpy, slide;
      slide = null;
      methodSpy = null;
      beforeEach(inject($controller, $rootScope, QuizItemModelsService)(function() {
        var scope;
        scope = $rootScope.$new();
        spyOn(QuizItemModelsService, 'get').andReturn({
          then: function(cb) {
            return cb(quizItems);
          }
        });
        return slide = $controller('SlideCtrl', {
          $scope: scope,
          QuizItemModelsService: QuizItemModelsService
        });
      }));
      it('should start at the intro page on startup', function() {
        return expect(slide.curPageTemplate).toBe(slide.pageTemplates.intro);
      });
      return it('should call `get` on `QuizItemModelsService`', function() {});
    });
  });

}).call(this);
