angular.module('test')

  .controller 'SlideCtrl', ['QuizModelService',
    (QuizModelService) ->
      @quizItems = QuizModelService.get()
      @
  ]
