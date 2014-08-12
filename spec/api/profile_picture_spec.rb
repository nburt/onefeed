require 'rails_helper'

describe "getting a user's facebook profile picture" do
  describe "get '/api/profile_picture'" do
    it 'gets a facebook profile picture given a user id' do
      body = {
        'data' => {
          'url' => 'https=>//fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c10.0.50.50/p50x50/544089_10202552316910864_1418490882_s.jpg',
          'is_silhouette' => false
        }
      }.to_json

      stub_request(:get, 'https://graph.facebook.com/10203694030092980/picture?redirect=false').
        to_return(:body => body)

      create_user
      expected_body = {
        url: 'https=>//fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c10.0.50.50/p50x50/544089_10202552316910864_1418490882_s.jpg'
      }.to_json

      post '/sessions', {"utf8" => "✓", "authenticity_token" => "foo", "session" => {"email" => "nate@example.com", "remember_me" => "0", "password" => "password"}, "commit" => "Login"}
      get '/api/profile_picture?user_id=10203694030092980'

      expect(response.status).to eq 200
      expect(response.body).to eq expected_body
    end
  end
end