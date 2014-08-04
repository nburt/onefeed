require 'rails_helper'

describe "getting a user's instagram timeline" do
  describe "get '/api/feed'" do
    it 'should get the latest 5 instagram posts for a user' do
      body = File.read("./spec/support/instagram_responses/timeline_response_count_5.json")

      stub_request(:get, "https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5").
        to_return(status: 200, body: body)

      user = create_user
      create_instagram_account(user)
      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/feed'
      expect(response.status).to eq 200
      expect(response.body).to eq body
    end

    it 'will return an error if a request to instagram is made with an invalid token' do
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
      expect(response.body).to eq body
    end

    it 'will get the next 25 instagram posts if it has a pagination id' do
      body = File.read("./spec/support/instagram_responses/timeline_response_count_5.json")

      stub_request(:get, "https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=25&max_id=778569615424721376_42804963").
        to_return(status: 200, body: body)

      user = create_user
      create_instagram_account(user)
      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/feed?instagram=778569615424721376_42804963'
      expect(response.status).to eq 200
      expect(response.body).to eq body
    end
  end
end