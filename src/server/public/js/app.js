//@ sourceMappingURL=app.map
(function() {
  var app;

  app = angular.module('test', []);

  app.controller('AppCtrl', function() {});

  app = angular.module('test');

  app.controller('NotificationCtrl', [
    'BootstrapService', function(BootstrapService) {
      var _this = this;
      this.alerts = BootstrapService.get();
      this.hasNotifications = function() {
        var _ref;
        return !!((_ref = _this.alerts) != null ? _ref.length : void 0);
      };
      return this.close = function(index) {
        return _this.alerts.splice(index, 1);
      };
    }
  ]);

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
