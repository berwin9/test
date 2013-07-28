app = angular.module 'test'

app.controller 'NotificationCtrl', ['$timeout', 'BootstrapService',
  ($timeout, BootstrapService) ->
    @alerts = BootstrapService.get()

    # angular 1.1.5 bugs out if we return a Promise so $timeout
    # can't be the last statement on the controller
    $timeout (=> @alerts.length = 0 if @alerts?), 10000

    @hasNotifications = => !!(@alerts?.length)

    @close = (index) => @alerts.splice(index, 1)
]
