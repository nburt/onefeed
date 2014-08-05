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
          $scope.posts = {success: true, body: data.data, pagination: data.pagination.next_max_id};
        }).
        error(function () {
          $scope.posts = {
            success: false,
            body: "Your account is no longer authorized. Please reauthorize your Instagram account by visiting your account page."
          }
        });
    };

    $scope.nextFeed = function () {
      var url = "/api/feed?instagram=" + $scope.posts.pagination;
      $http.get(url).success(function (data) {
        $scope.posts.success = true;
        for (var i = 0; i < data.data.length; i++) {
          $scope.posts.body.push(data.data[i]);
        }
        $scope.posts.pagination = data.pagination.next_max_id;
      })
    }
  }]);
})();