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
        expect($rootScope.posts).toEqual({errors: false});
        $httpBackend.expectGET('/api/feed');
        $rootScope.initialFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          errors: false,
          success: true,
          body: instagramResponses.instagramInitialFeed.body,
          pagination: {instagram: instagramResponses.instagramInitialFeed.body.pagination.next_max_id}
        });
      });

      it("returns an error message if a user's instagram access token is invalid", function () {
        $httpBackend.when('GET', '/api/feed').respond(
          400, {
            timeline: [],
            status: {instagram: 400, twitter: 204},
            pagination: {}
          }
        );
        createController();
        expect($rootScope.posts).toEqual({errors: false});
        $httpBackend.expectGET('/api/feed');
        $rootScope.initialFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          errors: true,
          error: "Your account is no longer authorized. Please reauthorize the following accounts on your account page: Instagram."
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
        expect($rootScope.posts).toEqual({errors: false});
        $httpBackend.expectGET('/api/feed');
        $rootScope.initialFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          success: true,
          errors: false,
          body: twitterResponses.initialFeed.timeline,
          pagination: twitterResponses.initialFeed.pagination
        });
      });

      it("returns an error message if the twitter access token is invalid", function () {
        $httpBackend.when('GET', '/api/feed').respond(
          400, {
            timeline: [],
            status: {instagram: 204, twitter: 401},
            pagination: {}
          }
        );

        createController();
        expect($rootScope.posts).toEqual({errors: false});
        $httpBackend.expectGET('/api/feed');
        $rootScope.initialFeed();
        $httpBackend.flush();

        expect($rootScope.posts).toEqual({
          errors: true,
          error: "Your account is no longer authorized. Please reauthorize the following accounts on your account page: Twitter."
        });
      });

      it("returns an error message if the twitter and instagram access tokens are invalid", function () {
        $httpBackend.when('GET', '/api/feed').respond(
          400, {
            timeline: [],
            status: {instagram: 400, twitter: 401},
            pagination: {}
          }
        );

        createController();
        expect($rootScope.posts).toEqual({errors: false});
        $httpBackend.expectGET('/api/feed');
        $rootScope.initialFeed();
        $httpBackend.flush();

        expect($rootScope.posts).toEqual({
          errors: true,
          error: "Your account is no longer authorized. Please reauthorize the following accounts on your account page: Instagram, Twitter."
        });
      });

      it("returns an error message if the twitter access token is invalid and the instagram token is valid", function () {
        $httpBackend.when('GET', '/api/feed').respond(
          200, {
            timeline: instagramResponses.instagramInitialFeed.body,
            status: {instagram: 200, twitter: 401},
            pagination: {instagram: '776999430264003590_1081226094'}
          }
        );
        createController();
        expect($rootScope.posts).toEqual({errors: false});
        $httpBackend.expectGET('/api/feed');
        $rootScope.initialFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          success: true,
          body: instagramResponses.instagramInitialFeed.body,
          pagination: {instagram: '776999430264003590_1081226094'},
          errors: true,
          error: "Your account is no longer authorized. Please reauthorize the following accounts on your account page: Twitter."
        });
      });

      it("returns an error message if the instagram access token is invalid and the twitter token is valid", function () {
        $httpBackend.when('GET', '/api/feed').respond(
          200, {
            timeline: twitterResponses.initialFeed.timeline,
            status: {instagram: 400, twitter: 200},
            pagination: twitterResponses.initialFeed.pagination
          }
        );
        createController();
        expect($rootScope.posts).toEqual({errors: false});
        $httpBackend.expectGET('/api/feed');
        $rootScope.initialFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          success: true,
          body: twitterResponses.initialFeed.timeline,
          pagination: twitterResponses.initialFeed.pagination,
          errors: true,
          error: "Your account is no longer authorized. Please reauthorize the following accounts on your account page: Instagram."
        });
      });
    });

    describe("getting subsequent feeds", function () {

      it("makes a request for 25 more instagram posts when a user clicks on the load more posts link", function () {
        $httpBackend.when('GET', '/api/feed?instagram=776999430264003590_1081226094&twitter=undefined').respond(
          200, {
            timeline: instagramResponses.instagramNextFeed.body,
            status: {instagram: 200, twitter: 204},
            pagination: {instagram: instagramResponses.instagramNextFeed.body.pagination.next_max_id}
          }
        );

        createController();

        $rootScope.posts = {
          errors: false,
          body: instagramResponses.instagramInitialFeed.body.data,
          pagination: {instagram: instagramResponses.instagramInitialFeed.body.pagination.next_max_id}
        };

        var body = $rootScope.posts.body;

        for (var i = 0; i < instagramResponses.instagramNextFeed.body.data.length; i++) {
          body.push(instagramResponses.instagramNextFeed.body.data[i])
        }

        $httpBackend.expectGET('/api/feed?instagram=776999430264003590_1081226094&twitter=undefined');
        $rootScope.nextFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          errors: false,
          body: body,
          pagination: {instagram: instagramResponses.instagramNextFeed.body.pagination.next_max_id},
          success: true
        });
      });

      it("returns an error message if a user's instagram access token is invalid", function () {
        $httpBackend.when('GET', '/api/feed?instagram=776999430264003590_1081226094&twitter=undefined').respond(
          400, {
            timeline: [],
            status: {instagram: 400, twitter: 204},
            pagination: {}
          }
        );

        createController();

        $rootScope.posts = {
          errors: false,
          body: instagramResponses.instagramInitialFeed.body.data,
          pagination: {instagram: instagramResponses.instagramInitialFeed.body.pagination.next_max_id}
        };

        $httpBackend.expectGET('/api/feed?instagram=776999430264003590_1081226094&twitter=undefined');
        $rootScope.nextFeed();
        $httpBackend.flush();
        expect($rootScope.posts).toEqual({
          errors: true,
          body: instagramResponses.instagramInitialFeed.body.data,
          pagination: {instagram: instagramResponses.instagramInitialFeed.body.pagination.next_max_id},
          error: "Your account is no longer authorized. Please reauthorize the following accounts on your account page: Instagram."
        });
      });

      it("makes a request for 25 more twitter posts when a user clicks on the load more posts link", function () {
        $httpBackend.when('GET', '/api/feed?instagram=undefined&twitter=462320636392919041').respond(
          200, {
            timeline: twitterResponses.nextFeed,
            status: {instagram: 204, twitter: 200},
            pagination: {twitter: twitterResponses.nextFeed.pagination}
          }
        );

        createController();

        $rootScope.posts = {
          success: true,
          errors: false,
          body: twitterResponses.initialFeed.timeline,
          pagination: twitterResponses.initialFeed.pagination
        };

        var body = $rootScope.posts.body;

        for (var i = 0; i < twitterResponses.nextFeed.length; i++) {
          body.push(twitterResponses.nextFeed[i])
        }

        $httpBackend.expectGET('/api/feed?instagram=undefined&twitter=462320636392919041');
        $rootScope.nextFeed();
        $httpBackend.flush();

        expect($rootScope.posts).toEqual({
          success: true,
          errors: false,
          body: body,
          pagination: {twitter: twitterResponses.nextFeed.pagination}
        });
      });

      it("returns an error message is the twitter access token is invalid", function () {
        $httpBackend.when('GET', '/api/feed?instagram=undefined&twitter=462320636392919041').respond(
          400, {
            timeline: [],
            status: {instagram: 204, twitter: 401},
            pagination: {}
          }
        );

        createController();

        $rootScope.posts = {
          success: true,
          errors: false,
          body: twitterResponses.initialFeed.timeline,
          pagination: twitterResponses.initialFeed.pagination
        };

        $httpBackend.expectGET('/api/feed?instagram=undefined&twitter=462320636392919041');
        $rootScope.nextFeed();
        $httpBackend.flush();

        expect($rootScope.posts).toEqual({
          success: true,
          errors: true,
          body: twitterResponses.initialFeed.timeline,
          pagination: twitterResponses.initialFeed.pagination,
          error: "Your account is no longer authorized. Please reauthorize the following accounts on your account page: Twitter."
        });
      });
    });
  });
});