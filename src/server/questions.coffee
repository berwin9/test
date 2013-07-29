module.exports = (app) ->
  init: ->
    QuizItemAnswerModel = app.QuizItemAnswerModel
    QuizItemModel = app.QuizItemModel

    q1answers = [
      new QuizItemAnswerModel
        answer: 'Prevent pollution of global scope'
      new QuizItemAnswerModel
        answer: 'Encapsulation'
      new QuizItemAnswerModel
        answer: 'Private properties and methods'
      new QuizItemAnswerModel
        answer: 'Allow conditional use of \'strict mode\''
    ]

    q1 = new QuizItemModel
      orderNumber: 1
      question: 'Which is not an advantage of using a closure?'
      correctAnswers: [q1answers[3]]
      possibleAnswers: q1answers

    q2answers = [
      new QuizItemAnswerModel
        answer: '<div>+<span>'
      new QuizItemAnswerModel
        answer: '<tr>+<td>'
      new QuizItemAnswerModel
        answer: '<ul>+<li>'
      new QuizItemAnswerModel
        answer: '<p>+<br>'
      new QuizItemAnswerModel
        answer: 'none of these'
      new QuizItemAnswerModel
        answer: 'all of these'
    ]

    q2 = new QuizItemModel
      orderNumber: 2
      question:
        """
        To create a columned list of two-line email subjects and dates for
        a master-detail view, which are the most semantically correct?
        """
      correctAnswers: [q2answers[1]]
      possibleAnswers: q2answers

    q3answers = [
      new QuizItemAnswerModel
        answer: 'fn.apply(this, stringsArray)'
      new QuizItemAnswerModel
        answer: 'fn.call(this, stringsArray)'
      new QuizItemAnswerModel
        answer: 'fn.bind(this, stringsArray)'
    ]

    q3 = new QuizItemModel
      orderNumber: 3
      question: 'To pass an array of strings to a function, you should not use...'
      correctAnswers: [q3answers[2]]
      possibleAnswers: q3answers

    q4answers = [
      new QuizItemAnswerModel
        answer: 'stub answer'
    ]

    q4 = new QuizItemModel
      orderNumber: 4
      question:
        """
        ____ and ____ would be the HTML tags you
        would use to display a menu item and its description.'
        """
      correctAnswers: q4answers
      possibleAnswers: q4answers

    q5answers = [
      new QuizItemAnswerModel
        answer: 'getElementById("outer").children[0]'
      new QuizItemAnswerModel
        answer: 'getElementsByClassName("inner")[0]'
    ]

    q5 = new QuizItemModel
      orderNumber: 5
      question:
        """
        Given <div id=”outer”><div class=”inner”></div></div>,
        which of these two is the most performant way to select the inner div?
        """
      correctAnswers: [q5answers[0]]
      possibleAnswers: q5

    q6answers = [
      new QuizItemAnswerModel
        answer: '1'
      new QuizItemAnswerModel
        answer: '2'
      new QuizItemAnswerModel
        answer: '3'
    ]

    q6 = new QuizItemModel
      orderNumber: 6
      question:
        """
        Given this:

        angular.module('myModule').service('myService',function() {
          var message = "Message one!"
          var getMessage = function() {
            return this.message
          }
          this.message = "Message two!"
          this.getMessage = function() { return message }

          function() {
            {
              getMessage: getMessage,
              message: "Message three!"
            }
          }
        }

        Which message will be returned by injecting this service
        and executing "myService.getMessage()"
        """
      correctAnswers: q6answers
      possibleAnswers: q6answers


    model.save() for model in [q1, q2, q3, q4, q5, q6]
