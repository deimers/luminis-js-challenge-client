app = angular.module('app', [])

app.config ['$httpProvider', ($httpProvider) ->
  delete $httpProvider.defaults.headers.common["X-Requested-With"]
]

chatApiUrl = (path) -> 'http://luminisjschallenge-server.azurewebsites.net' + path
# chatApiUrl = (path) -> 'luminisjschallenge.herokuapp.com' + path

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
    if $scope.selectedUser?
      $scope.updateUsers()
      $scope.updateMessages()
    $timeout $scope.poll, 1500
]