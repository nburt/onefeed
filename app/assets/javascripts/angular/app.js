window.App = angular.module("onefeed", ['ngSanitize']);
App.config(['$sceDelegateProvider', function($sceDelegateProvider){
  $sceDelegateProvider.resourceUrlWhitelist([
    'self',
    'https://fbcdn-video-a.akamaihd.net/**',
    'http://www.youtube.com**',
    'https://www.youtube.com**'
  ]);
}]);