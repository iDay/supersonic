angular
  .module('core')
  .controller 'IndexController', ($scope, supersonic) ->
    $scope.pongs = 0

    $scope.ping = ->
      supersonic.debug.ping().then ->
        $scope.pongs++

    $scope.pingWithCallback = ->
      supersonic.debug.ping
        onSuccess: ->
          $scope.pongs++
