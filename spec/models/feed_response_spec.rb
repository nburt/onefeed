require 'rails_helper'

describe FeedResponse do
  it 'returns a feed response object given an instagram response, twitter response, and facebook_response' do
    instagram_body = File.read("./spec/support/instagram_responses/instagram_feed_response_data.json")
    stub_request(:get, "https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5").
      to_return(status: 200, body: instagram_body)
    instagram_response = Typhoeus.get("https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5")

    twitter_tweet1 = Twitter::Tweet.new(id: 1, created_at: "2014-08-01 12:52:08 -0600")
    twitter_tweet2 = Twitter::Tweet.new(id: 2, created_at: "2014-05-25 14:35:03 -0600")
    twitter_response = Struct.new(:body, :code).new([twitter_tweet1, twitter_tweet2], 200)

    facebook_body = File.read("./spec/support/facebook_responses/facebook_response_data.json")
    stub_request(:get, "https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5").
      to_return(status: 200, body: facebook_body)
    facebook_response = Typhoeus.get("https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5")

    feed_response = FeedResponse.new(instagram_response, twitter_response, facebook_response)

    expected_timeline = []

    expected_timeline << {
      "id" => "1405512339732980_1454738551477025",
      "created_at" => "1406919636",
      "provider" => "facebook"
    }

    expected_timeline << {
      "id" => "777616973866382080_236856963",
      "created_at" => "1406919188",
      "provider" => "instagram"
    }

    expected_timeline << Twitter::Tweet.new(id: 1, created_at: "1406919128", provider: "twitter").to_h.stringify_keys

    expected_timeline << {
      "id" => "10201679188771997_10202306493694228",
      "created_at" => "1406918112",
      "provider" => "facebook"
    }

    expected_timeline << {
      "id" => "777400586609077963_375325234",
      "created_at" => "1406893393",
      "provider" => "instagram"
    }

    expected_timeline << Twitter::Tweet.new(id: 2, created_at: "1401050103", provider: "twitter").to_h.stringify_keys

    expect(feed_response.timeline).to eq expected_timeline
    expect(feed_response.status).to eq({instagram: 200, twitter: 200, facebook: 200})
    expect(feed_response.pagination).to eq({instagram: "776999430264003590_1081226094", twitter: "2", facebook: "1407764111"})
  end

end