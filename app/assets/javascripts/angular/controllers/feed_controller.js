(function () {
  var app = angular.module('onefeed', []);

  app.filter('fromNow', function () {
    return function (date) {
      return moment(date).fromNow();
    };
  });

  app.controller('FeedController', ['$scope', '$http', function ($scope, $http) {

    $scope.posts = {};

    $scope.initialFeed = function () {
      $http.get('/api/feed').
        success(function (data, status) {
          $scope.posts = {status: status, body: data.data, pagination: data.pagination.next_max_id};
        }).
        error(function (data, status) {
          $scope.posts = {
            status: status,
            body: "Your account is no longer authorized. Please reauthorize your Instagram account by visiting your account page."
          }
        });
    };

    $scope.nextFeed = function () {
      var url = "/api/feed?instagram=" + $scope.posts.pagination;
      $http.get(url).success(function(data) {
        $scope.posts.status = 200;
        for (var i = 0; i < data.data.length; i++) {
          $scope.posts.body.push(data.data[i]);
        }
        $scope.posts.pagination = data.pagination.next_max_id;
      })
    }
  }]);
})();