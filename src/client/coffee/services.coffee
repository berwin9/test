app = angular.module 'test'

app.factory 'BootstrapService', ->
  get: ->
    window.__bootstrapData.notifications if window.__bootstrapData?
