require 'rails_helper'

describe "getting a user's instagram timeline" do
  describe "get '/api/instagram-initial-feed'" do
    it 'should get the latest 5 posts for a user' do
      body = File.read("./spec/support/instagram_responses/timeline_response_count_5.json")

      stub_request(:get, "https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5").
        to_return(status: 200, body: body)

      user = create_user
      create_instagram_account(user)
      post '/sessions', {"utf8" => "✓", "authenticity_token" => "iiSX8wJWGDOGPcxjst8Fb1CptcE518hrjq+vIM1XeIk=", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/instagram-initial-feed'
      expected_response = body
      expect(response.status).to eq 200
      expect(response.body).to eq expected_response
    end
  end
end