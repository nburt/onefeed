describe("instagramFeedController", function () {

  describe("getting the initial feed", function () {
    var $rootScope, $httpBackend;

    beforeEach(module('onefeed'));

    beforeEach(inject(function ($injector) {
      $httpBackend = $injector.get('$httpBackend');
      $rootScope = $injector.get('$rootScope');
      var $controller = $injector.get('$controller');
      createController = function () {
        return $controller('instagramFeedController', {$scope: $rootScope});
      };
    }));

    afterEach(function () {
      $httpBackend.verifyNoOutstandingExpectation();
      $httpBackend.verifyNoOutstandingRequest();
    });

    it("makes an initial request for the feed", function () {
      $httpBackend.when('GET', '/api/instagram-initial-feed').respond(200, testResponses.instagramInitialFeed.body);
      createController();
      expect($rootScope.instagramPosts).toEqual([]);
      $httpBackend.expectGET('/api/instagram-initial-feed');
      $rootScope.initialInstagramFeed();
      $httpBackend.flush();
      expect($rootScope.instagramPosts).toEqual({status: 200, body: testResponses.instagramInitialFeed.body.data});
    });

    it("will return an error message if a user's access token is invalid", function () {
      $httpBackend.when('GET', '/api/instagram-initial-feed').respond(400, testResponses.instagramInitialFeedError.body);
      createController();
      expect($rootScope.instagramPosts).toEqual([]);
      $httpBackend.expectGET('/api/instagram-initial-feed');
      $rootScope.initialInstagramFeed();
      $httpBackend.flush();
      expect($rootScope.instagramPosts).toEqual({
        status: 400,
        body: "Your account is no longer authorized. Please reauthorize your Instagram account by visiting your account page."
      });
    })
  });
});