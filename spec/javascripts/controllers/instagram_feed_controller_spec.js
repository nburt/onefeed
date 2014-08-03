describe("instagramFeedController", function () {

  var $rootScope, $httpBackend;

  beforeEach(module('onefeed'));

  beforeEach(inject(function($injector) {
    $httpBackend = $injector.get('$httpBackend');
    $httpBackend.when('GET', '/api/instagram-initial-feed').respond(testResponses.instagramInitialFeed.body);
    $rootScope = $injector.get('$rootScope');
    var $controller = $injector.get('$controller');
    createController = function() {
      return $controller('instagramFeedController', {$scope : $rootScope });
    };
  }));

  afterEach(function () {
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });

  it("makes an initial request for the feed", function () {
    var controller = createController();
    expect($rootScope.instagramPosts).toEqual([]);
    $httpBackend.expectGET('/api/instagram-initial-feed');
    $rootScope.initialInstagramFeed();
    $httpBackend.flush();
    expect($rootScope.instagramPosts).toEqual(testResponses.instagramInitialFeed.body.data);
  });
});