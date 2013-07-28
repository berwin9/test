app = angular.module 'demo'

app.controller 'NotificationCtrl', ['BootstrapService', (BootstrapService) ->
  @alerts = BootstrapService.get()
