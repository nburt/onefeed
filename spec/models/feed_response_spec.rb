require 'rails_helper'

describe FeedResponse do
  it 'returns a feed response object given a Typhoeus response' do
    body = File.read("./spec/support/instagram_responses/timeline_response_count_5.json")

    stub_request(:get, "https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5").
      to_return(status: 200, body: body)
    response = Typhoeus.get("https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5")

    feed_response = FeedResponse.new(response)

    expect(feed_response.timeline).to eq Oj.load(body)
    expect(feed_response.status).to eq({instagram: 200})
  end
end