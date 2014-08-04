describe("FeedController", function () {

  describe("getting the initial feed", function () {
    var $rootScope, $httpBackend;

    beforeEach(module('onefeed'));

    beforeEach(inject(function ($injector) {
      $httpBackend = $injector.get('$httpBackend');
      $rootScope = $injector.get('$rootScope');
      var $controller = $injector.get('$controller');
      createController = function () {
        return $controller('FeedController', {$scope: $rootScope});
      };
    }));

    afterEach(function () {
      $httpBackend.verifyNoOutstandingExpectation();
      $httpBackend.verifyNoOutstandingRequest();
    });

    it("makes an initial request for the feed", function () {
      $httpBackend.when('GET', '/api/feed').respond(200, testResponses.instagramInitialFeed.body);
      createController();
      expect($rootScope.posts).toEqual({});
      $httpBackend.expectGET('/api/feed');
      $rootScope.initialFeed();
      $httpBackend.flush();
      expect($rootScope.posts).toEqual({
        status: 200,
        body: testResponses.instagramInitialFeed.body.data,
        pagination: testResponses.instagramInitialFeed.body.pagination.next_max_id
      });
    });

    it("will return an error message if a user's access token is invalid", function () {
      $httpBackend.when('GET', '/api/feed').respond(400, testResponses.instagramInitialFeedError.body);
      createController();
      expect($rootScope.posts).toEqual({});
      $httpBackend.expectGET('/api/feed');
      $rootScope.initialFeed();
      $httpBackend.flush();
      expect($rootScope.posts).toEqual({
        status: 400,
        body: "Your account is no longer authorized. Please reauthorize your Instagram account by visiting your account page."
      });
    });

    it("will make a request for 25 more posts when a user clicks on the load more posts link", function () {
      $httpBackend.when('GET', '/api/feed?instagram=776999430264003590_1081226094').respond(200, testResponses.instagramNextFeed.body);
      createController();

      $rootScope.posts = {
        status: 200,
        body: testResponses.instagramInitialFeed.body.data,
        pagination: testResponses.instagramInitialFeed.body.pagination.next_max_id
      };

      var body = $rootScope.posts.body;

      for (var i = 0; i < testResponses.instagramNextFeed.body.data.length; i++) {
        body.push(testResponses.instagramNextFeed.body.data[i])
      }

      $httpBackend.expectGET('/api/feed?instagram=776999430264003590_1081226094');
      $rootScope.nextFeed('/api/feed?instagram=776999430264003590_1081226094');
      $httpBackend.flush();
      expect($rootScope.posts).toEqual({
        status: 200,
        body: body,
        pagination: testResponses.instagramNextFeed.body.pagination.next_max_id
      });
    });
  });
});