// Generated by CoffeeScript 1.6.2
(function() {
  var app, chatApiUrl,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  app = angular.module('app', ['ngResource']);

  app.config(['$httpProvider', function($httpProvider) {}]);

  chatApiUrl = function(path) {
    return 'http://luminisjschallenge-server.azurewebsites.net' + path;
  };

  app.factory('Chat', [
    '$resource', function($resource) {
      return $resource(chatApiUrl('/:userName/'));
    }
  ]);

  app.controller('ChatCtrl', [
    '$scope', 'Chat', '$http', '$timeout', function($scope, Chat, $http, $timeout) {
      $http.defaults.useXDomain = true;
      $scope.login = function(userName) {
        return $scope.users = Chat.query(function() {
          var exists, userNames;

          userNames = $scope.users.map(function(user) {
            return user.name;
          });
          exists = userNames.some(function(name) {
            return name === userName;
          });
          if (__indexOf.call(userNames, userName) < 0) {
            $http.post(chatApiUrl("/"), {
              name: userName
            });
          }
          return $scope.poll();
        });
      };
      $scope.selectUser = function(userName) {
        $scope.selectedUser = userName;
        return $scope.messages = Chat.query({
          userName: userName
        });
      };
      $scope.sendMessage = function() {
        $http.post(chatApiUrl("/" + $scope.selectedUser), {
          sender: $scope.nick,
          content: $scope.messageToSend
        });
        return $scope.messageToSend = '';
      };
      return $scope.poll = function() {
        if ($scope.selectedUser != null) {
          Chat.query({
            userName: $scope.selectedUser
          }, function(messages) {
            return $scope.messages = messages;
          });
          Chat.query(function(users) {
            return $scope.users = users;
          });
        }
        return $timeout($scope.poll, 1500);
      };
    }
  ]);

}).call(this);