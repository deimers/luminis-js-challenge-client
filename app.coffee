app = angular.module('app', ['ngResource'])

app.config ['$httpProvider', ($httpProvider) ->
  # delete $httpProvider.defaults.headers.common["X-Requested-With"]
]

chatApiUrl = (path) -> 'http://luminisjschallenge-server.azurewebsites.net' + path

app.controller 'ChatCtrl', ['$scope', '$http', '$timeout', ($scope, $http, $timeout) ->
  $scope.login = (userName) -> 
    $http.get(chatApiUrl("/")).success (data) ->    
      $scope.users = data
      userNames = $scope.users.map (user) -> user.name 
      exists = userNames.some (name) -> name is userName
      unless userName in userNames
        $http.post(chatApiUrl("/"),{name: userName})
      $scope.poll()  

  $scope.selectUser = (userName) ->
    $scope.selectedUser = userName

  $scope.sendMessage = ->
    $http.post(chatApiUrl("/#{$scope.selectedUser}"),{sender: $scope.nick, content: $scope.messageToSend})
    $scope.messageToSend = ''

  $scope.poll = ->
    if $scope.selectedUser?
      $http.get(chatApiUrl("/#{$scope.selectedUser}")).success (data) ->
        $scope.messages = data
      $http.get(chatApiUrl("/")).success (data) ->
         $scope.users = data
    $timeout $scope.poll, 1000
]