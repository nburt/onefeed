require 'rails_helper'

describe Feed do
  describe "Getting feeds" do
    it 'can get the instagram feed' do
      body = File.read("./spec/support/instagram_responses/timeline_response_count_5.json")
      user = create_user
      create_instagram_account(user)

      stub_request(:get, "https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5").
        to_return(status: 200, body: body)

      time_formatted_body = File.read("./spec/support/instagram_responses/time_edited_timeline_response_count_5.json")

      expected_timeline = Oj.load(time_formatted_body)["data"]
      expected_timeline.map { |post| post["provider"] = "instagram" }

      expected = {
        timeline: expected_timeline,
        status: {instagram: 200, twitter: 204},
        pagination: {instagram: Oj.load(time_formatted_body)["pagination"]["next_max_id"]}
      }

      feed = Feed.new(user)
      feed_response = feed.timeline
      expect(feed_response.timeline).to eq expected[:timeline]
      expect(feed_response.status).to eq expected[:status]
      expect(feed_response.pagination).to eq expected[:pagination]
    end

    it 'can get the twitter feed' do
      body = File.read("./spec/support/twitter_responses/timeline_response_count_5.json")
      user = create_user
      create_twitter_account(user)

      stub_request(:get, "https://api.twitter.com/1.1/statuses/home_timeline.json?count=5").
        to_return(status: 200, body: body)

      expected = {
        timeline: TIMELINE_2.map do |post|
          post[:created_at] = "#{Time.parse(post[:created_at]).to_i}"
          post[:provider] = "twitter"
          post.stringify_keys
        end,
        status: {instagram: 204, twitter: 200},
        pagination: {twitter: Oj.load(body).last["id"].to_s}
      }

      feed = Feed.new(user)
      feed_response = feed.timeline
      expect(feed_response.timeline).to eq expected[:timeline]
      expect(feed_response.status).to eq expected[:status]
      expect(feed_response.pagination).to eq expected[:pagination]
    end
  end
end