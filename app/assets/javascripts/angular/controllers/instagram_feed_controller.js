(function () {
  var app = angular.module('onefeed', []);

  app.filter('fromNow', function () {
    return function (date) {
      return moment(date).fromNow();
    }
  });

  app.controller('instagramFeedController', ['$scope', '$http', function ($scope, $http) {

    $scope.instagramPosts = [];

    $scope.initialInstagramFeed = function () {
      $http.get('/api/instagram-initial-feed').
        success(function (response) {
          $scope.instagramPosts = {status: 200, body: response.data};
        }).
        error(function () {
          $scope.instagramPosts = {
            status: 400,
            body: "Your account is no longer authorized. Please reauthorize your Instagram account by visiting your account page."
          }
        });
    };
  }]);
})();