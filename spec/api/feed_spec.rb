require 'rails_helper'

describe "getting a user's instagram timeline" do
  describe "get '/api/feed'" do
    it 'should get the latest 5 instagram posts for a user' do
      body = File.read("./spec/support/instagram_responses/timeline_response_count_5.json")

      stub_request(:get, "https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5").
        to_return(status: 200, body: body)

      time_formatted_body = File.read("./spec/support/instagram_responses/time_edited_timeline_response_count_5.json")

      expected_timeline = Oj.load(time_formatted_body)["data"]
      expected_timeline.map { |post| post["provider"] = "instagram" }

      expected_response_body = {
        timeline: expected_timeline,
        status: {instagram: 200, twitter: 204, facebook: 204},
        pagination: {instagram: Oj.load(time_formatted_body)["pagination"]["next_max_id"]}
      }.to_json

      user = create_user
      create_instagram_account(user)
      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/feed'
      expect(response.status).to eq 200
      expect(response.body).to eq expected_response_body
    end

    it 'will return an empty array if a request to instagram is made with an invalid token' do
      body = {
        "meta" => {
          "error_type" => "OAuthParameterException",
          "code" => 400,
          "error_message" => "The access_token provided is invalid."
        }
      }.to_json

      stub_request(:get, "https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5").
        to_return(status: 400, body: body)

      user = create_user
      create_instagram_account(user)
      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/feed'
      expect(response.status).to eq 400
      expect(response.body).to eq(
                                 {
                                   timeline: [],
                                   status: {instagram: 400, twitter: 204, facebook: 204},
                                   pagination: {}
                                 }.to_json
                               )
    end

    it 'will get the next 25 instagram posts if it has a pagination id' do
      body = File.read("./spec/support/instagram_responses/timeline_response_count_5.json")

      stub_request(:get, "https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=25&max_id=778569615424721376_42804963").
        to_return(status: 200, body: body)

      time_formatted_body = File.read("./spec/support/instagram_responses/time_edited_timeline_response_count_5.json")

      expected_timeline = Oj.load(time_formatted_body)["data"]
      expected_timeline.map { |post| post["provider"] = "instagram" }

      expected_response_body = {
        timeline: expected_timeline,
        status: {instagram: 200, twitter: 204, facebook: 204},
        pagination: {instagram: Oj.load(time_formatted_body)["pagination"]["next_max_id"]}
      }.to_json

      user = create_user
      create_instagram_account(user)
      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/feed?instagram=778569615424721376_42804963'
      expect(response.status).to eq 200
      expect(response.body).to eq expected_response_body
    end

    it 'will get the latest 5 twitter posts' do
      body = File.read("./spec/support/twitter_responses/timeline_response_count_5.json")

      stub_request(:get, "https://api.twitter.com/1.1/statuses/home_timeline.json?count=5").
        to_return(status: 200, body: body)

      user = create_user
      create_twitter_account(user)

      expected_timeline = TIMELINE.map do |post|
        post[:created_at] = "#{Time.parse(post[:created_at]).to_i}"
        post[:provider] = "twitter"
        post.stringify_keys
      end

      expected_response_body = {
        timeline: expected_timeline,
        status: {instagram: 204, twitter: 200, facebook: 204},
        pagination: {twitter: "462321101763522561"}
      }.to_json

      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/feed'

      expect(response.status).to eq 200
      expect(response.body).to eq expected_response_body
    end

    it 'will return an empty array if a request to twitter is made with an invalid token' do
      body = {
        "errors" => [
          {
            "message" => "Could not authenticate you",
            "code" => 135
          }
        ]
      }.to_json

      stub_request(:get, "https://api.twitter.com/1.1/statuses/home_timeline.json?count=5").
        to_return(status: 401, body: body)

      user = create_user
      create_twitter_account(user)
      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/feed'
      expect(response.status).to eq 400
      expect(response.body).to eq(
                                 {
                                   timeline: [],
                                   status: {instagram: 204, twitter: 401, facebook: 204},
                                   pagination: {}
                                 }.to_json
                               )
    end

    it 'will get the next 25 twitter posts if it has a pagination id' do
      body = File.read('./spec/support/twitter_responses/timeline_response_count_5.json')

      stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json?count=26&max_id=462323298248843264').
        to_return(status: 200, body: body)

      expected_timeline = TIMELINE_4.map do |post|
        post[:created_at] = "#{Time.parse(post[:created_at]).to_i}"
        post[:provider] = "twitter"
        post.stringify_keys
      end

      expected_timeline.shift

      expected_response_body = {
        timeline: expected_timeline,
        status: {instagram: 204, twitter: 200, facebook: 204},
        pagination: {twitter: "462321101763522561"}
      }.to_json

      user = create_user
      create_twitter_account(user)
      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/feed?twitter=462323298248843264'
      expect(response.status).to eq 200
      expect(response.body).to eq expected_response_body
    end

    it 'will get a facebook feed' do
      body = File.read('./spec/support/facebook_responses/timeline_response_count_2.json')
      stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
        to_return(status: 200, body: body)

      user = create_user
      create_facebook_account(user)

      expected_timeline = File.read('./spec/support/facebook_responses/time_formatted_timeline_response_count_2.json')

      expected_response_body = {
        timeline: Oj.load(expected_timeline),
        status: {instagram: 204, twitter: 204, facebook: 200},
        pagination: {facebook: '1407764111'}
      }.to_json

      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/feed'

      expect(response.status).to eq 200
      expect(response.body).to eq expected_response_body
    end

    it 'will get the next range of facebook posts if there is a pagination id' do
      body = File.read('./spec/support/facebook_responses/timeline_response_count_3.json')
      stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=25&until=1407764111').
        to_return(status: 200, body: body)

      user = create_user
      create_facebook_account(user)

      expected_timeline = File.read('./spec/support/facebook_responses/time_formatted_timeline_response_count_3.json')

      expected_response_body = {
        timeline: Oj.load(expected_timeline)["data"],
        status: {instagram: 204, twitter: 204, facebook: 200},
        pagination: {facebook: "1407746831"}
      }.to_json

      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/feed?instagram=undefined&twitter=undefined&facebook=1407764111'

      expect(response.status).to eq 200
      expect(response.body).to eq expected_response_body
    end

    it 'will get a combined feed of instagram, twitter, and facebook posts' do
      instagram_body = File.read('./spec/support/instagram_responses/timeline_response_count_1.json')
      twitter_body = File.read('./spec/support/twitter_responses/timeline_response_count_2.json')
      facebook_body = File.read('./spec/support/facebook_responses/timeline_response_count_1.json')

      stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5').
        to_return(status: 200, body: instagram_body)

      stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json?count=5').
        to_return(status: 200, body: twitter_body)

      stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
        to_return(status: 200, body: facebook_body)

      user = create_user
      create_instagram_account(user)
      create_twitter_account(user)
      create_facebook_account(user)

      instagram_post = Oj.load(
        File.read('./spec/support/instagram_responses/time_edited_response_count_1.json')
      )['data'].first
      instagram_post['provider'] = 'instagram'

      twitter_timeline = Oj.load(twitter_body).map do |post|
        post['created_at'] = "#{Time.parse(post['created_at']).to_i}"
        post['provider'] = 'twitter'
        post
      end

      facebook_post = Oj.load(
        File.read('./spec/support/facebook_responses/time_formatted_timeline_response_count_1.json')
      )['data'].first

      expected_timeline = []
      expected_timeline << twitter_timeline[0]
      expected_timeline << instagram_post
      expected_timeline << facebook_post
      expected_timeline << twitter_timeline[1]

      expected_response_body = {
        timeline: expected_timeline,
        status: {instagram: 200, twitter: 200, facebook: 200},
        pagination: {instagram: '776999430264003590_1081226094', twitter: '462321453514240000', facebook: '1407764111'}
      }.to_json

      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/feed'

      expect(response.status).to eq 200
      expect(response.body).to eq expected_response_body
    end
  end
end
