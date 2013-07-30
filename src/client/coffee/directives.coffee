angular.module('test')

  .directive 'testMarkdown', ->
    renderMarkdown = (text) -> markdown.toHTML text
    restrict: 'A'
    link: (scope, elem, attrs) ->
      $elem = angular.element(elem)
      $elem.html renderMarkdown(attrs.testMarkdown)
      attrs.$observe 'testMarkdown', (newValue, oldValue) ->
        $elem.html renderMarkdown(newValue)
