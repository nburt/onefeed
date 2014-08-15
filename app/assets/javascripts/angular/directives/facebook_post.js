(function () {
  App.directive('facebookPost', ['$http', function ($http) {

    function getProfilePicture(scope, element) {
      function updatePicture(imgSelector, newImgSrc) {
        element.find(imgSelector).attr('src', newImgSrc)
      }

      $http.get('/api/profile_picture?user_id=' + scope.post.from.id).
        success(function (data) {
          updatePicture('.user-profile-picture', data.url);
        });

      if (scope.post.to && scope.post.to.data.length == 1) {
        $http.get('/api/profile_picture?user_id=' + scope.post.to.data[0].id).
          success(function (data) {
            updatePicture('.friend-profile-picture', data.url);
          });
      }
    }

    return {
      restrict: 'AE',
      templateUrl: 'assets/facebook_post.html',
      link: getProfilePicture
    };
  }]);
})();