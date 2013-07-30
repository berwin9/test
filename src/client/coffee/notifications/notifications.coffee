angular.module('test')

  .controller 'NotificationCtrl', ['$timeout', 'BootstrapService',
    ($timeout, BootstrapService) ->
      @alerts = BootstrapService.get()

      @hasNotifications = => !!(@alerts?.length)

      @close = (index) => @alerts.splice(index, 1)

      # coffeescripts implied return causes bugs (caused by promises being the last expression)
      # when using angulars `controller as` syntax so we need to explicitly
      # return the controller instance
      @
  ]
