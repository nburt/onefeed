window.App = angular.module("onefeed", ['ngSanitize']);
App.config(function($sceDelegateProvider){
  $sceDelegateProvider.resourceUrlWhitelist([
    'self',
    'https://fbcdn-video-a.akamaihd.net/**'
  ]);
});