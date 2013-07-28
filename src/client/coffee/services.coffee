angular.module('test')

  .factory 'BootstrapService', ->
    get: ->
      window.__bootstrapData.notifications if window.__bootstrapData?
