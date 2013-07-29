angular.module('test')

  .controller 'NotificationCtrl', ['$timeout', 'BootstrapService',
    ($timeout, BootstrapService) ->
      @notificationLimit = 3
      @alerts = BootstrapService.get()

      reduceAlerts = =>
        if @alerts?
          if @alerts.length > @notificationLimit
            @alerts.length = @alerts.length - @notificationLimit
            $timeout reduceAlerts, 5000
          else @alerts.length = 0

      # angular 1.1.5 bugs out if we return a Promise so $timeout
      # can't be the last statement on the controller
      $timeout (->
        reduceAlerts() if @alerts? and !!@alerts.length
      ), 10000

      @hasNotifications = => !!(@alerts?.length)

      @close = (index) => @alerts.splice(index, 1)

      @pushNotification = (message) =>
        @alerts = [] if @alerts?
        @alerts.push message

      # because of coffeescripts implied return at end, this causes bugs
      # when using angulars `controller as` syntax so we need to explicitly
      # return the controller instance
      @
  ]
