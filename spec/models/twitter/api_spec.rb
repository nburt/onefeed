require 'rails_helper'

describe Twitter::Api do
  it 'can make a request for the twitter timeline' do
    body = File.read("./spec/support/twitter_responses/timeline_response_count_2.json")

    stub_request(:get, "https://api.twitter.com/1.1/statuses/home_timeline.json?count=5").
      to_return(status: 200, body: body)

    user = create_user
    create_twitter_account(user)

    parsed_body = Oj.load(body)

    tweet_1 = Twitter::Tweet.new(parsed_body.first.symbolize_keys)
    tweet_2 = Twitter::Tweet.new(parsed_body.last.symbolize_keys)

    twitter_api = Twitter::Api.new(user)
    response = twitter_api.feed
    expect(response.body).to eq [tweet_1, tweet_2]
    expect(response.code).to eq 200
  end

  it 'will return a NullResponse object if a user does not have a twitter account' do
    user = create_user
    twitter_api = Twitter::Api.new(user)
    response = twitter_api.feed
    expect(response.body).to eq []
    expect(response.code).to eq 204
  end
end