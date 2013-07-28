(function() {
  var app;

  app = angular.module('test', []);

  app.controller('AppCtrl', function() {});

}).call(this);

(function() {
  var app;

  app = angular.module('test');

  app.controller('NotificationCtrl', [
    '$timeout', 'BootstrapService', function($timeout, BootstrapService) {
      var _this = this;
      this.alerts = BootstrapService.get();
      $timeout((function() {
        if (_this.alerts != null) {
          return _this.alerts.length = 0;
        }
      }), 10000);
      this.hasNotifications = function() {
        var _ref;
        return !!((_ref = _this.alerts) != null ? _ref.length : void 0);
      };
      return this.close = function(index) {
        return _this.alerts.splice(index, 1);
      };
    }
  ]);

}).call(this);

(function() {
  var app;

  app = angular.module('test');

  app.factory('BootstrapService', function() {
    return {
      get: function() {
        if (window.__bootstrapData != null) {
          return window.__bootstrapData.notifications;
        }
      }
    };
  });

}).call(this);
