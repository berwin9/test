app = angular.module 'demo'

app.factory 'BootstrapService', () ->
  get: -> __bootstrapData
