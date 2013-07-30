(function() {
  var __hasProp = {}.hasOwnProperty;

  describe('services', function() {
    beforeEach(module('test'));
    describe('questions url', function() {
      return it('should be /questions', inject(function(quizItemModelsUrl) {
        return expect(quizItemModelsUrl).toBe('/questions');
      }));
    });
    describe('QuizItemModelsService', function() {
      var $httpBackend, QuizItemModelsService;
      $httpBackend = null;
      QuizItemModelsService = null;
      beforeEach(inject(function(_$httpBackend_, _QuizItemModelsService_) {
        $httpBackend = _$httpBackend_;
        QuizItemModelsService = _QuizItemModelsService_;
        $httpBackend.whenGET().respond(fakePayload);
        return QuizItemModelsService.get();
      }));
      it('should build `n` number of quiz models equal to payload', function() {
        var cache, cacheLength, key, value;
        cache = QuizItemModelsService.getQuizItemModelsCache();
        cacheLength = 0;
        for (key in cache) {
          if (!__hasProp.call(cache, key)) continue;
          value = cache[key];
          ++cacheLength;
        }
        expect(cacheLength).toBe(0);
        $httpBackend.flush();
        cache = QuizItemModelsService.getQuizItemModelsCache();
        for (key in cache) {
          if (!__hasProp.call(cache, key)) continue;
          value = cache[key];
          ++cacheLength;
        }
        return expect(cacheLength).toBe(fakePayload.length);
      });
      it('should build `n` number of answer models equal to payload', function() {
        var cache, cacheLength, key, value;
        cache = QuizItemModelsService.getQuizAnswerModelsCache();
        cacheLength = 0;
        for (key in cache) {
          if (!__hasProp.call(cache, key)) continue;
          value = cache[key];
          ++cacheLength;
        }
        expect(cacheLength).toBe(0);
        $httpBackend.flush();
        cache = QuizItemModelsService.getQuizAnswerModelsCache();
        for (key in cache) {
          if (!__hasProp.call(cache, key)) continue;
          value = cache[key];
          ++cacheLength;
        }
        return expect(cacheLength).toBe(3);
      });
      it('should build the quiz models', function() {
        var cache, cacheItem;
        $httpBackend.flush();
        cache = QuizItemModelsService.getQuizItemModelsCache();
        cacheItem = cache['1'];
        expect(cacheItem).not.toBe(null);
        expect(cacheItem.id).toBe('1');
        expect(cacheItem.question).toBe('1?');
        return expect(cacheItem.orderNumber).toBe(1);
      });
      return it('should build the answer models', function() {
        var cache, cacheItem;
        $httpBackend.flush();
        cache = QuizItemModelsService.getQuizAnswerModelsCache();
        cacheItem = cache['1'];
        expect(cacheItem).not.toBe(null);
        expect(cacheItem.id).toBe('1');
        return expect(cacheItem.answer).toBe('1');
      });
    });
    return describe('Models', function() {
      var cache;
      cache = null;
      beforeEach(inject(function(_$httpBackend_, _QuizItemModelsService_) {
        var $httpBackend, QuizItemModelsService;
        $httpBackend = _$httpBackend_;
        QuizItemModelsService = _QuizItemModelsService_;
        $httpBackend.whenGET().respond(fakePayload);
        QuizItemModelsService.get();
        $httpBackend.flush();
        return cache = QuizItemModelsService.getQuizItemModelsCache();
      }));
      return it('should validate if the answer is correct', function() {
        expect(cache['1'].isValidAnswer('1')).toBe(true);
        expect(cache['1'].isValidAnswer('2')).not.toBe(true);
        expect(cache['2'].isValidAnswer('2')).toBe(true);
        return expect(cache['2'].isValidAnswer('1')).not.toBe(true);
      });
    });
  });

}).call(this);
