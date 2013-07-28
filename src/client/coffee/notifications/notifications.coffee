app = angular.module 'test'

app.controller 'NotificationCtrl', ['BootstrapService', (BootstrapService) ->
  @alerts = BootstrapService.get()

  @hasNotifications = => !!(@alerts?.length)

  @close = (index) => @alerts.splice(index, 1)
]
