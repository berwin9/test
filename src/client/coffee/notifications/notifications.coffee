angular.module('test')

  .controller 'NotificationCtrl', ['$timeout', 'BootstrapService',
    ($timeout, BootstrapService) ->
      @notificationLimit = 3
      @alerts = BootstrapService.get()

      # angular 1.1.5 bugs out if we return a Promise so $timeout
      # can't be the last statement on the controller
      reduceAlerts = =>
        if @alerts?
          if @alerts.length > @notificationLimit
            @alerts.length = @alerts.length - @notificationLimit
            $timeout reduceAlerts, 5000
          else @alerts.length = 0

      $timeout (->
        reduceAlerts() if @alerts? and !!@alerts.length
      ), 10000

      @hasNotifications = => !!(@alerts?.length)

      @close = (index) => @alerts.splice(index, 1)
  ]
