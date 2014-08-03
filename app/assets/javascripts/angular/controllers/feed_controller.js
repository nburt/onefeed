(function () {
  var app = angular.module('onefeed', []);

  app.filter('fromNow', function () {
    return function (date) {
      return moment(date).fromNow();
    }
  });

  app.controller('FeedController', ['$scope', '$http', function ($scope, $http) {

    $scope.posts = [];

    $scope.initialFeed = function () {
      $http.get('/api/feed').
        success(function (response) {
          $scope.posts = {status: 200, body: response.data};
        }).
        error(function () {
          $scope.posts = {
            status: 400,
            body: "Your account is no longer authorized. Please reauthorize your Instagram account by visiting your account page."
          }
        });
    };
  }]);
})();