angular.module('test')

  .factory 'BootstrapService', ->
    get: ->
      window.__bootstrapData.notifications if window.__bootstrapData?

  .factory 'QuizModelService', ->
    get: ->
      [
        { questions: 'why', correctAnwers: [1], possibleAnswers: ['a', 'b'] }
        { questions: 'why', correctAnwers: [1], possibleAnswers: ['a', 'b'] }
      ]
