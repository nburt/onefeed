describe("FeedController", function () {

  describe("getting feeds", function () {
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

    describe("getting the initial feed", function () {

      it("makes an initial request for the feed", function () {
        $httpBackend.when('GET', '/api/feed').respond(
          200, {timeline: testResponses.instagramInitialFeed.body, status: {instagram: 200}}
        );
        createController();
        expect($rootScope.posts).toEqual({});
        $httpBackend.expectGET('/api/feed');
        $rootScope.initialFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          success: true,
          body: testResponses.instagramInitialFeed.body.data,
          pagination: testResponses.instagramInitialFeed.body.pagination.next_max_id
        });
      });

      it("will return an error message if a user's access token is invalid", function () {
        $httpBackend.when('GET', '/api/feed').respond(
          400, {timeline: testResponses.instagramFeedError.body, status: {instagram: 400}}
        );
        createController();
        expect($rootScope.posts).toEqual({});
        $httpBackend.expectGET('/api/feed');
        $rootScope.initialFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          success: false,
          body: "Your account is no longer authorized. Please reauthorize your Instagram account by visiting your account page."
        });
      });
    });

    describe("getting subsequent feeds", function () {

      it("will make a request for 25 more posts when a user clicks on the load more posts link", function () {
        $httpBackend.when('GET', '/api/feed?instagram=776999430264003590_1081226094').respond(
          200, {timeline: testResponses.instagramNextFeed.body, status: {instagram: 200}}
        );
        createController();

        $rootScope.posts = {
          success: true,
          body: testResponses.instagramInitialFeed.body.data,
          pagination: testResponses.instagramInitialFeed.body.pagination.next_max_id
        };

        var body = $rootScope.posts.body;

        for (var i = 0; i < testResponses.instagramNextFeed.body.data.length; i++) {
          body.push(testResponses.instagramNextFeed.body.data[i])
        }

        $httpBackend.expectGET('/api/feed?instagram=776999430264003590_1081226094');
        $rootScope.nextFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          success: true,
          body: body,
          pagination: testResponses.instagramNextFeed.body.pagination.next_max_id
        });
      });

      it("will return an error message if a user's access token is invalid", function () {
        $httpBackend.when('GET', '/api/feed?instagram=776999430264003590_1081226094').respond(
          400, {timeline: testResponses.instagramFeedError.body, status: {instagram: 400}}
        );
        createController();

        $rootScope.posts = {
          success: true,
          body: testResponses.instagramInitialFeed.body.data,
          pagination: testResponses.instagramInitialFeed.body.pagination.next_max_id
        };

        $httpBackend.expectGET('/api/feed?instagram=776999430264003590_1081226094');
        $rootScope.nextFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          success: false,
          body: "Your account is no longer authorized. Please reauthorize your Instagram account by visiting your account page."
        });
      });
    });
  });
});