(function() {
  describe('controllers', function() {
    beforeEach(function() {
      return module('test');
    });
    describe('SlideCtrl', function() {
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
        expect(slide.curQuizItem.id).toBe(quizItems[2].id);
        return expect(slide.curQuizItem.id).toBe(slide.quizItems[2].id);
      });
      it('should set the correct active model when clicking on the pagination', function() {
        expect(slide.curActiveQuizIndex).toBe(null);
        $httpBackend.flush();
        slide.onSlideIndexClick(2);
        expect(slide.curActiveQuizIndex).toBe(2);
        expect(slide.curQuizItem.id).toBe(quizItems[2].id);
        return expect(slide.curQuizItem.id).toBe(slide.quizItems[2].id);
      });
      it('should go to the next question when the next button is clicked', function() {
        expect(slide.curActiveQuizIndex).toBe(null);
        $httpBackend.flush();
        slide.onNextIndexClick();
        expect(slide.curActiveQuizIndex).toBe(0);
        expect(slide.curQuizItem.id).toBe(quizItems[0].id);
        expect(slide.curQuizItem.id).toBe(slide.quizItems[0].id);
        slide.onNextIndexClick();
        expect(slide.curActiveQuizIndex).toBe(1);
        expect(slide.curQuizItem.id).toBe(quizItems[1].id);
        return expect(slide.curQuizItem.id).toBe(slide.quizItems[1].id);
      });
      it('should go to the previous question when the next button is clicked', function() {
        expect(slide.curActiveQuizIndex).toBe(null);
        $httpBackend.flush();
        slide.setActiveModelByIndex(2);
        slide.onPrevIndexClick();
        expect(slide.curActiveQuizIndex).toBe(1);
        expect(slide.curQuizItem.id).toBe(quizItems[1].id);
        return expect(slide.curQuizItem.id).toBe(slide.quizItems[1].id);
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
      it('should not go out of bounds of the arrays length when prev is clicked', function() {
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
      it('should check if current index is the active index', function() {
        $httpBackend.flush();
        slide.setActiveModelByIndex(2);
        expect(slide.isActiveIndex(2)).toBe(true);
        return expect(slide.isActiveIndex(1)).toBe(false);
      });
      it('should set the current answer for the model', function() {
        $httpBackend.flush();
        slide.setActiveModelByIndex(1);
        expect(slide.curQuizItem.userAnswerId).toBe(null);
        slide.setAnswer('1');
        return expect(slide.curQuizItem.userAnswerId).toBe('1');
      });
      it('should check if the current answer is the valid one for this quiz model', function() {
        $httpBackend.flush();
        slide.setActiveModelByIndex(1);
        expect(slide.isValidAnswer(slide.quizItems[1], quizItems[1])).toBe(true);
        return expect(slide.isValidAnswer(slide.quizItems[1], quizItems[2])).toBe(false);
      });
      it('should sum the correct answers', function() {
        $httpBackend.flush();
        slide.setActiveModelByIndex(1);
        slide.setAnswer('2');
        slide.setPageTemplate(slide.pageTemplates.results);
        return expect(slide.sumCorrectAnswers()).toBe(1);
      });
      it('should start quiz at model 0 when `initQuiz` is called', function() {
        $httpBackend.flush();
        slide.setPageTemplate(slide.pageTemplates.results);
        slide.setActiveModelByIndex(2);
        expect(slide.curActiveQuizIndex).toBe(2);
        slide.initQuiz();
        return expect(slide.curActiveQuizIndex).toBe(0);
      });
      describe('template switch', function() {
        beforeEach(function() {
          return $httpBackend.flush();
        });
        it('should set the correct page template type', function() {
          slide.setPageTemplate(slide.pageTemplates.intro);
          expect(slide.curPageTemplate).toBe(slide.pageTemplates.intro);
          slide.setPageTemplate(slide.pageTemplates.results);
          return expect(slide.curPageTemplate).toBe(slide.pageTemplates.results);
        });
        it('should reset the quiz when template is switched to intro', function() {
          slide.setActiveModelByIndex(1);
          slide.setAnswer('1');
          expect(slide.curQuizItem.userAnswerId).toBe('1');
          slide.setPageTemplate(slide.pageTemplates.intro);
          return expect(slide.quizItems[1].userAnswerId).toBe(null);
        });
        return it('should validate models when user jumps to results', function() {
          slide.setActiveModelByIndex(1);
          slide.setAnswer('2');
          expect(slide.curQuizItem.isValid()).toBe(false);
          slide.setPageTemplate(slide.pageTemplates.results);
          return expect(slide.curQuizItem.isValid()).toBe(true);
        });
      });
      return it('should retrieve the associated possible answer models for this current quiz model', function() {
        var results;
        $httpBackend.flush();
        results = slide.getPossibleAnswersByIds([1, 2]);
        expect(results[0].id).toBe('1');
        return expect(results[1].id).toBe('2');
      });
    });
    return describe('ResultsCtrl', function() {
      var results;
      results = null;
      beforeEach(inject(function(_$controller_, $rootScope) {
        var $controller, scope;
        $controller = _$controller_;
        scope = $rootScope.$new();
        return results = $controller('ResultsCtrl', {
          $scope: scope
        });
      }));
      it('should default an index to a hidden state', function() {
        return expect(result.isHidden(1)).toBe(true);
      });
      return it('should toggle an items visibility state', function() {
        expect(results.isHidden(1)).toBe(true);
        results.toggleHide(1);
        return expect(results.isHidden(1)).toBe(false);
      });
    });
  });

}).call(this);
