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
        status: {instagram: 200, twitter: 204},
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
                                   status: {instagram: 400, twitter: 204},
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
        status: {instagram: 200, twitter: 204},
        pagination: {instagram: Oj.load(time_formatted_body)["pagination"]["next_max_id"]}
      }.to_json

      user = create_user
      create_instagram_account(user)
      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/feed?instagram=778569615424721376_42804963'
      expect(response.status).to eq 200
      expect(response.body).to eq expected_response_body
    end
  end
end