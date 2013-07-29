(function() {
  var app;

  app = angular.module('test', []);

  app.controller('AppCtrl', function() {});

}).call(this);

(function() {
  angular.module('test').controller('NotificationCtrl', [
    '$timeout', 'BootstrapService', function($timeout, BootstrapService) {
      var reduceAlerts,
        _this = this;
      this.notificationLimit = 3;
      this.alerts = BootstrapService.get();
      reduceAlerts = function() {
        if (_this.alerts != null) {
          if (_this.alerts.length > _this.notificationLimit) {
            _this.alerts.length = _this.alerts.length - _this.notificationLimit;
            return $timeout(reduceAlerts, 5000);
          } else {
            return _this.alerts.length = 0;
          }
        }
      };
      $timeout((function() {
        if ((this.alerts != null) && !!this.alerts.length) {
          return reduceAlerts();
        }
      }), 10000);
      this.hasNotifications = function() {
        var _ref;
        return !!((_ref = _this.alerts) != null ? _ref.length : void 0);
      };
      this.close = function(index) {
        return _this.alerts.splice(index, 1);
      };
      this.pushNotification = function(message) {
        if (_this.alerts != null) {
          _this.alerts = [];
        }
        return _this.alerts.push(message);
      };
      return this;
    }
  ]);

}).call(this);

(function() {
  var QuizItemAnswerModel, QuizItemModel;

  angular.module('test').value('quizItemModelsUrl', '/questions').factory('BootstrapService', function() {
    return {
      get: function() {
        if (window.__bootstrapData != null) {
          return window.__bootstrapData.notifications;
        }
      }
    };
  }).factory('QuizItemModelsService', [
    '$http', 'quizItemModelsUrl', function($http, quizItemModelsUrl) {
      var _quizItemAnswersModelCache, _quizItemModelCache;
      _quizItemModelCache = {};
      _quizItemAnswersModelCache = {};
      return {
        get: function() {
          return $http.get(quizItemModelsUrl).then(function(response) {
            var answerItem, correctAnswer, possibleAnswerIds, quizItem, quizItemAnswerModel, quizItemModel, quizItemModels, _i, _j, _len, _len1, _ref, _ref1;
            quizItemModels = [];
            _ref = response.data;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              quizItem = _ref[_i];
              quizItemModel = new QuizItemModel(quizItem._id, quizItem.question, quizItem.orderNumber);
              possibleAnswerIds = [];
              _ref1 = quizItem.possibleAnswers;
              for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
                answerItem = _ref1[_j];
                quizItemAnswerModel = new QuizItemAnswerModel(answerItem._id, answerItem.answer);
                possibleAnswerIds.push(quizItemAnswerModel.id);
                _quizItemAnswersModelCache[quizItemAnswerModel.id] = quizItemAnswerModel;
              }
              _quizItemModelCache[quizItemModel.id] = quizItemModel;
              quizItemModel.setPossibleAnswerIds(possibleAnswerIds);
              quizItemModel.setCorrectAnswerIds((function() {
                var _k, _len2, _ref2, _results;
                _ref2 = quizItem.correctAnswers;
                _results = [];
                for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
                  correctAnswer = _ref2[_k];
                  _results.push(correctAnswer._id);
                }
                return _results;
              })());
              quizItemModels.push(quizItemModel);
            }
            return quizItemModels;
          });
        },
        getAnswerModelsByIds: function(ids) {
          var id, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = ids.length; _i < _len; _i++) {
            id = ids[_i];
            _results.push(_quizItemAnswersModelCache[id]);
          }
          return _results;
        }
      };
    }
  ]);

  QuizItemModel = (function() {
    function QuizItemModel(id, question, orderNumber) {
      this.id = id;
      this.question = question;
      this.orderNumber = orderNumber;
      this.possibleAnswerIds = null;
      this.correctAnswerIds = null;
      this.userAnswerId = null;
    }

    QuizItemModel.prototype.validateUserAnswer = function() {};

    QuizItemModel.prototype.isAnswered = function() {
      return this.userQuizItemAnserModel != null;
    };

    QuizItemModel.prototype.setPossibleAnswerIds = function(arr) {
      return this.possibleAnswerIds = arr;
    };

    QuizItemModel.prototype.setCorrectAnswerIds = function(arr) {
      return this.correctAnswerIds = arr;
    };

    QuizItemModel.prototype.setUserAnswerId = function(id) {
      return this.userAnswerId = id;
    };

    QuizItemModel.prototype.reset = function() {
      return this.userAnswerId = null;
    };

    return QuizItemModel;

  })();

  QuizItemAnswerModel = (function() {
    function QuizItemAnswerModel(id, answer) {
      this.id = id;
      this.answer = answer;
    }

    return QuizItemAnswerModel;

  })();

}).call(this);

(function() {
  var initQuizDecorator;

  initQuizDecorator = function(ctrl) {
    return function(cb) {
      return function() {
        if (ctrl.curActiveQuizIndex == null) {
          ctrl.initQuiz();
        }
        return cb.apply(null, arguments);
      };
    };
  };

  angular.module('test').controller('SlideCtrl', [
    '$scope', 'QuizItemModelsService', function($scope, QuizItemModelsService) {
      var goToIntro, goToResults,
        _this = this;
      this.pageTemplates = {
        intro: 'intro.html',
        question: 'question.html',
        results: 'results.html'
      };
      this.curPageTemplate = this.pageTemplates.intro;
      this.quizItems = null;
      this.curActiveQuizIndex = null;
      this.curQuizItem = null;
      this.setActiveModelByIndex = function(index) {
        if (_this.quizItems != null) {
          _this.curActiveQuizIndex = index;
          return _this.curQuizItem = _this.quizItems[index];
        }
      };
      this.onSlideIndexClick = initQuizDecorator(this)(function(index) {
        return _this.setActiveModelByIndex(index);
      });
      this.onNextIndexClick = function() {
        if (_this.curActiveQuizIndex == null) {
          _this.setPageTemplate(_this.pageTemplates.question);
          return _this.setActiveModelByIndex(0);
        } else if (_this.curActiveQuizIndex !== _this.quizItems.length - 1) {
          return _this.setActiveModelByIndex(_this.curActiveQuizIndex + 1);
        }
      };
      this.onPrevIndexClick = initQuizDecorator(this)(function() {
        if (_this.curActiveQuizIndex !== 0) {
          return _this.setActiveModelByIndex(_this.curActiveQuizIndex - 1);
        }
      });
      QuizItemModelsService.get().then(function(models) {
        return _this.quizItems = models;
      });
      this.getPossibleAnswersByIds = function(ids) {
        if (ids != null) {
          return QuizItemModelsService.getAnswerModelsByIds(ids);
        }
      };
      this.setAnswer = function(id) {
        return _this.curQuizItem.setUserAnswerId(id);
      };
      this.resetQuiz = function() {
        var quizItem, _i, _len, _ref, _results;
        _ref = _this.quizItems;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          quizItem = _ref[_i];
          _results.push(quizItem.reset());
        }
        return _results;
      };
      this.initQuiz = function() {
        _this.curActiveQuizIndex = 0;
        _this.setActiveModelByIndex(_this.curActiveQuizIndex);
        return _this.setPageTemplate(_this.pageTemplates.question);
      };
      this.setPageTemplate = function(template) {
        _this.curPageTemplate = template;
        switch (template) {
          case _this.pageTemplates.intro:
            return goToIntro();
          case _this.pageTemplates.results:
            return goToResults();
        }
      };
      this.isActiveIndex = function(index) {
        return _this.curActiveQuizIndex === index;
      };
      goToIntro = function() {
        return _this.resetQuiz();
      };
      goToResults = function() {
        var quizItem, _i, _len, _ref, _results;
        _ref = _this.quizItems;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          quizItem = _ref[_i];
          _results.push(quizItem.validate());
        }
        return _results;
      };
      return this;
    }
  ]);

}).call(this);
