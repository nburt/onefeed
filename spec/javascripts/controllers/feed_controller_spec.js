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

      it("makes an initial request for the instagram feed", function () {
        $httpBackend.when('GET', '/api/feed').respond(
          200, {
            timeline: instagramResponses.instagramInitialFeed.body,
            status: {instagram: 200, twitter: 204},
            pagination: {instagram: '776999430264003590_1081226094'}}
        );
        createController();
        expect($rootScope.posts).toEqual({});
        $httpBackend.expectGET('/api/feed');
        $rootScope.initialFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          success: true,
          body: instagramResponses.instagramInitialFeed.body,
          pagination: {instagram: instagramResponses.instagramInitialFeed.body.pagination.next_max_id}
        });
      });

      it("will return an error message if a user's instagram access token is invalid", function () {
        $httpBackend.when('GET', '/api/feed').respond(
          400, {
            timeline: instagramResponses.instagramFeedError.body,
            status: {instagram: 400, twitter: 204},
            pagination: {}
          }
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

      it("makes an initial request for the twitter feed", function () {
        $httpBackend.when('GET', '/api/feed').respond(
          200, {
            timeline: twitterResponses.initialFeed.timeline,
            status: twitterResponses.initialFeed.status,
            pagination: twitterResponses.initialFeed.pagination
          }
        );
        createController();
        expect($rootScope.posts).toEqual({});
        $httpBackend.expectGET('/api/feed');
        $rootScope.initialFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          success: true,
          body: twitterResponses.initialFeed.timeline,
          pagination: twitterResponses.initialFeed.pagination
        });
      });
    });

    describe("getting subsequent feeds", function () {

      it("will make a request for 25 more instagram posts when a user clicks on the load more posts link", function () {
        $httpBackend.when('GET', '/api/feed?instagram=776999430264003590_1081226094').respond(
          200, {
            timeline: instagramResponses.instagramNextFeed.body,
            status: {instagram: 200, twitter: 204},
            pagination: {instagram: instagramResponses.instagramNextFeed.body.pagination.next_max_id}
          }
        );
        createController();

        $rootScope.posts = {
          success: true,
          body: instagramResponses.instagramInitialFeed.body.data,
          pagination: {instagram: instagramResponses.instagramInitialFeed.body.pagination.next_max_id}
        };

        var body = $rootScope.posts.body;

        for (var i = 0; i < instagramResponses.instagramNextFeed.body.data.length; i++) {
          body.push(instagramResponses.instagramNextFeed.body.data[i])
        }

        $httpBackend.expectGET('/api/feed?instagram=776999430264003590_1081226094');
        $rootScope.nextFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          success: true,
          body: body,
          pagination: {instagram: instagramResponses.instagramNextFeed.body.pagination.next_max_id}
        });
      });

      it("will return an error message if a user's instagram access token is invalid", function () {
        $httpBackend.when('GET', '/api/feed?instagram=776999430264003590_1081226094').respond(
          400, {
            timeline: instagramResponses.instagramFeedError.body,
            status: {instagram: 400, twitter: 204},
            pagination: {}
          }
        );
        createController();

        $rootScope.posts = {
          success: true,
          body: instagramResponses.instagramInitialFeed.body.data,
          pagination: {instagram: instagramResponses.instagramInitialFeed.body.pagination.next_max_id}
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