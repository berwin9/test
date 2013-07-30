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
        quizItems = [new Models.QuizItemModel('1', '1?', 1), new Models.QuizItemModel('2', '2?', 2), new Models.QuizItemModel('3', '3?', 3)];
        quizAnswers = [new Models.QuizItemAnswerModel(1, '1'), new Models.QuizItemAnswerModel(1, '2'), new Models.QuizItemAnswerModel(1, '3')];
        for (_i = 0, _len = quizItems.length; _i < _len; _i++) {
          quizItem = quizItems[_i];
          quizItem.setPossibleAnswerIds([1, 2]);
        }
        for (index = _j = 0, _len1 = quizItems.length; _j < _len1; index = ++_j) {
          quizItem = quizItems[index];
          quizItem.setCorrectAnswerIds([index]);
        }
        $httpBackend.expectGET().respond(fakePayload);
        methodSpy = spyOn(QuizItemModelsService, 'get').andCallThrough({
          then: function(cb) {
            return cb(quizItems);
          }
        });
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
      it('should set the active model by index', function() {
        expect(slide.curActiveQuizIndex).toBe(null);
        $httpBackend.flush();
        slide.setActiveModelByIndex(2);
        expect(slide.curActiveQuizIndex).toBe(2);
        return expect(slide.curQuizItem.id).toBe(quizItems[2].id);
      });
      it('should set the correct active model when clicking on the pagination', function() {
        expect(slide.curActiveQuizIndex).toBe(null);
        $httpBackend.flush();
        slide.onSlideIndexClick(2);
        expect(slide.curActiveQuizIndex).toBe(2);
        return expect(slide.curQuizItem.id).toBe(quizItems[2].id);
      });
      it('should go to the next question when the next button is clicked', function() {
        expect(slide.curActiveQuizIndex).toBe(null);
        $httpBackend.flush();
        slide.onNextIndexClick();
        expect(slide.curActiveQuizIndex).toBe(0);
        expect(slide.curQuizItem.id).toBe(quizItems[0].id);
        slide.onNextIndexClick();
        expect(slide.curActiveQuizIndex).toBe(1);
        return expect(slide.curQuizItem.id).toBe(quizItems[1].id);
      });
      it('should go to the previous question when the next button is clicked', function() {
        expect(slide.curActiveQuizIndex).toBe(null);
        $httpBackend.flush();
        slide.setActiveModelByIndex(2);
        slide.onPrevIndexClick();
        expect(slide.curActiveQuizIndex).toBe(1);
        return expect(slide.curQuizItem.id).toBe(quizItems[1].id);
      });
      it('should not go out of bounds of the arrays length when next is clicked', function() {
        var max;
        $httpBackend.flush();
        max = slide.quizItems.length - 1;
        slide.setActiveModelByIndex(max);
        slide.onNextIndexClick();
        slide.onNextIndexClick();
        expect(slide.curActiveQuizIndex).toBe(max);
        expect(slide.curQuizItem.id).toBe(quizItems[max].id);
        return slide.setActiveModelByIndex(max);
      });
      return it('should not go out of bounds of the arrays length when prev is clicked', function() {
        var item, _i, _ref, _results;
        $httpBackend.flush();
        _results = [];
        for (item = _i = 0, _ref = slide.quizItems.length + 1; 0 <= _ref ? _i <= _ref : _i >= _ref; item = 0 <= _ref ? ++_i : --_i) {
          slide.onPrevIndexClick();
          expect(slide.curActiveQuizIndex).toBe(0);
          _results.push(expect(slide.curQuizItem.id).toBe(quizItems[0].id));
        }
        return _results;
      });
    });
  });

}).call(this);
