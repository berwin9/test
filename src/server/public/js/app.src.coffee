app = angular.module 'test', []

app.controller 'AppCtrl', ->

app = angular.module 'test'

app.controller 'NotificationCtrl', ['BootstrapService', (BootstrapService) ->
  @alerts = BootstrapService.get()

  @hasNotifications = => !!(@alerts?.length)

  @close = (index) => @alerts.splice(index, 1)
]

app = angular.module 'test'

app.factory 'BootstrapService', ->
  get: ->
    if window.__bootstrapData?
      return window.__bootstrapData.notifications
