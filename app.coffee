app = angular.module('app', [])

chatApiUrl = (path) -> 'http://planetmarrs.xs4all.nl:8787/server' + path
# chatApiUrl = (path) -> 'http://luminisjschallenge.herokuapp.com' + path
# chatApiUrl = (path) -> 'http://luminisjschallenge-server.azurewebsites.net' + path

app.controller 'ChatCtrl', ['$scope', '$http', '$timeout', ($scope, $http, $timeout) ->

  $scope.$watch 'loggedIn', -> 
    if $scope.loggedIn
      $http.get(chatApiUrl("/")).success (data) ->
        $scope.users = data
        userNames = $scope.users.map (user) -> user.name 
        $http.post(chatApiUrl("/"),{name: $scope.nick}) unless $scope.nick in userNames
        $scope.poll()

  $scope.selectUser = (userName) ->
    $scope.selectedUser = userName
    $scope.updateMessages()

  $scope.sendMessage = ->
    $http.post(chatApiUrl("/#{$scope.selectedUser}"),{sender: $scope.nick, content: $scope.messageToSend})
    $scope.messageToSend = ''

  $scope.updateMessages = ->
    $http.get(chatApiUrl("/#{$scope.selectedUser}")).success (data) ->
      $scope.messages = data
        
  $scope.updateUsers = ->      
    $http.get(chatApiUrl("/")).success (data) ->
      $scope.users = data
    
  $scope.poll = ->
    $scope.updateUsers()
    if $scope.selectedUser?
      $scope.updateMessages()
    timer = $timeout $scope.poll, 1000
    $timeout.cancel timer unless $scope.loggedIn
]