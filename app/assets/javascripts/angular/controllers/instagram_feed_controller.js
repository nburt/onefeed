(function () {
  var app = angular.module('onefeed', []);

  app.filter('fromNow', function () {
    return function(date) {
      return moment(date).fromNow();
    }
  });

  app.controller('instagramFeedController', function ($scope, $http) {

    $scope.instagramPosts = [];

    $scope.initialInstagramFeed = function () {
      $http.get('/api/instagram-initial-feed').success(function (response) {
        $scope.instagramPosts = response.data;
      });
    };
  });
})();