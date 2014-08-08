require 'rails_helper'

describe Feed do
  describe "Getting feeds" do
    it 'can get the instagram feed' do
      body = File.read("./spec/support/instagram_responses/timeline_response_count_5.json")
      user = create_user
      create_instagram_account(user)

      stub_request(:get, "https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5").
        to_return(status: 200, body: body)

      feed = Feed.new(user)
      feed_response = feed.timeline
      expect(feed_response.timeline).to eq Oj.load(body)
      expect(feed_response.status).to eq(instagram: 200)
    end
  end
end