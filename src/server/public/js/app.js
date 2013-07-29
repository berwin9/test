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
      return this;
    }
  ]);

}).call(this);

(function() {
  angular.module('test').factory('BootstrapService', function() {
    return {
      get: function() {
        if (window.__bootstrapData != null) {
          return window.__bootstrapData.notifications;
        }
      }
    };
  }).factory('QuizModelService', function() {
    return {
      get: function() {
        return [
          {
            questions: 'why',
            correctAnwers: [1],
            possibleAnswers: ['a', 'b']
          }, {
            questions: 'why',
            correctAnwers: [1],
            possibleAnswers: ['a', 'b']
          }
        ];
      }
    };
  });

}).call(this);

(function() {
  angular.module('test').controller('SlideCtrl', [
    'QuizModelService', function(QuizModelService) {
      this.quizItems = QuizModelService.get();
      return this;
    }
  ]);

}).call(this);
