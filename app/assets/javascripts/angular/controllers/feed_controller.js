(function () {
  App.filter('fromNow', function () {
    return function (date) {
      return moment(date).fromNow();
    };
  });

  App.controller('FeedController', ['$scope', '$http', function ($scope, $http) {

    $scope.posts = {};

    $scope.initialFeed = function () {
      $http.get('/api/feed').
        success(function (data) {
          $scope.posts = {success: true, body: data.timeline, pagination: data.pagination}
        }).
        error(function () {
          $scope.posts = {
            success: false,
            body: "Your account is no longer authorized. Please reauthorize your Instagram account by visiting your account page."
          }
        });
    };

    $scope.nextFeed = function () {
      var url = "/api/feed?instagram=" + $scope.posts.pagination.instagram;
      $http.get(url).
        success(function (data) {
          $scope.posts.success = true;
          for (var i = 0; i < data.timeline.length; i++) {
            $scope.posts.body.push(data.timeline[i]);
          }
          $scope.posts.pagination = data.pagination;
        }).
        error(function () {
          $scope.posts = {
            success: false,
            body: "Your account is no longer authorized. Please reauthorize your Instagram account by visiting your account page."
          }
        });
    }
  }]);
})();