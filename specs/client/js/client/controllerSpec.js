(function() {
  describe('controllers', function() {
    beforeEach(function() {
      return module('test');
    });
    return describe('SlideCtrl', function() {
      var $controller, $httpBackend, QuizItemModelsService, methodSpy, mockPromise, quizAnswers, quizItems, slide;
      slide = null;
      methodSpy = null;
      mockPromise = null;
      quizItems = null;
      quizAnswers = null;
      $httpBackend = null;
      $controller = null;
      QuizItemModelsService = null;
      beforeEach(inject(function(_$controller_, $rootScope, _QuizItemModelsService_, Models, _$httpBackend_) {
        var index, quizItem, scope, _i, _j, _len, _len1;
        $httpBackend = _$httpBackend_;
        $controller = _$controller_;
        QuizItemModelsService = _QuizItemModelsService_;
        $httpBackend.whenGET().respond(fakePayload);
        quizItems = [new Models.QuizItemModel(1, 'what is your item model number?', 1), new Models.QuizItemModel(2, 'what is your item model number?', 2)];
        quizAnswers = [new Models.QuizItemAnswerModel(1, '1'), new Models.QuizItemAnswerModel(1, '2')];
        for (_i = 0, _len = quizItems.length; _i < _len; _i++) {
          quizItem = quizItems[_i];
          quizItem.setPossibleAnswerIds([1, 2]);
        }
        for (index = _j = 0, _len1 = quizItems.length; _j < _len1; index = ++_j) {
          quizItem = quizItems[index];
          quizItem.setCorrectAnswerIds([index]);
        }
        $httpBackend.expectGET().respond(fakePayload);
        methodSpy = spyOn(QuizItemModelsService, 'get').andCallThrough();
        scope = $rootScope.$new();
        return slide = $controller('SlideCtrl', {
          $scope: scope,
          QuizItemModelsService: QuizItemModelsService
        });
      }));
      it('should start at the intro page on startup', function() {
        return expect(slide.curPageTemplate).toBe(slide.pageTemplates.intro);
      });
      it('should call `get` on `QuizItemModelsService`', function() {
        return expect(methodSpy.callCount).toBe(1);
      });
      it('should assign `@quizItems` when `QuizItemModelsService` response is back', function() {
        expect(slide.quizItems).toBe(null);
        $httpBackend.flush();
        return expect(slide.quizItems).not.toBe(null);
      });
      return it('should go to the first item', function() {
        return expect(slide.curActiveQuizIndex).toBe(null);
      });
    });
  });

}).call(this);
