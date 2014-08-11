(function () {
  App.filter('fromNow', function () {
    return function (date) {
      return moment(date).fromNow();
    };
  });

  App.controller('FeedController', ['$scope', '$http', function ($scope, $http) {

    $scope.posts = {errors: false};

    $scope.initialFeed = function () {
      $http.get('/api/feed').
        success(function (data) {
          $scope.posts = {success: true, body: data.timeline, pagination: data.pagination};
          $scope.setErrorResponse(data);
        }).
        error(function (data) {
          $scope.setErrorResponse(data)
        });
    };

    $scope.nextFeed = function () {
      var url = "/api/feed?instagram=" + $scope.posts.pagination.instagram + "&twitter=" + $scope.posts.pagination.twitter;
      $http.get(url).
        success(function (data) {
          $scope.posts.success = true;
          for (var i = 0; i < data.timeline.length; i++) {
            $scope.posts.body.push(data.timeline[i]);
          }
          $scope.posts.pagination = data.pagination;
          $scope.setErrorResponse(data);
        }).
        error(function (data) {
          $scope.setErrorResponse(data);
        });
    };

    $scope.setErrorResponse = function (data) {
      var unauthedProviders = [];
      if (data.status.instagram == 400) {
        unauthedProviders.push("Instagram");
      }

      if (data.status.twitter == 401) {
        unauthedProviders.push("Twitter");
      }

      if (unauthedProviders.length > 0) {
        var errorString = "Your account is no longer authorized. Please reauthorize the following accounts on your account page: ";

        for (var i = 0; i < unauthedProviders.length; i++) {
          if (i + 1 < unauthedProviders.length) {
            errorString += (unauthedProviders[i] + ", ");
          } else {
            errorString += (unauthedProviders[i] + ".");
          }
        }

        $scope.posts.errors = true;
        $scope.posts.error = errorString;
      } else {
        $scope.posts.errors = false;
      }
    }
  }]);
})();