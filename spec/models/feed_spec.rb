require 'rails_helper'

describe Feed do
  describe "Getting feeds" do
    it 'can get the instagram feed' do
      body = File.read('./spec/support/instagram_responses/timeline_response_count_5.json')
      user = create_user
      create_instagram_account(user)

      stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5').
        to_return(status: 200, body: body)

      time_formatted_body = File.read('./spec/support/instagram_responses/time_edited_timeline_response_count_5.json')

      expected_timeline = Oj.load(time_formatted_body)['data']
      expected_timeline.map { |post| post['provider'] = 'instagram' }

      expected = {
        timeline: expected_timeline,
        status: {instagram: 200, twitter: 204, facebook: 204},
        pagination: {instagram: Oj.load(time_formatted_body)['pagination']['next_max_id']}
      }

      feed = Feed.new(user)
      feed_response = feed.timeline

      expect(feed_response.timeline).to eq expected[:timeline]
      expect(feed_response.status).to eq expected[:status]
      expect(feed_response.pagination).to eq expected[:pagination]
    end

    it 'can get the instagram feed with pagination' do
      body = File.read('./spec/support/instagram_responses/timeline_response_count_5.json')

      stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=25&max_id=778569615424721376_42804963').
        to_return(status: 200, body: body)

      time_formatted_body = File.read('./spec/support/instagram_responses/time_edited_timeline_response_count_5.json')

      expected_timeline = Oj.load(time_formatted_body)['data']
      expected_timeline.map { |post| post['provider'] = 'instagram' }

      expected = {
        timeline: expected_timeline,
        status: {instagram: 200, twitter: 204, facebook: 204},
        pagination: {instagram: Oj.load(time_formatted_body)['pagination']['next_max_id']}
      }

      user = create_user
      create_instagram_account(user)

      params = {instagram: '778569615424721376_42804963', twitter: 'undefined', facebook: 'undefined'}

      feed = Feed.new(user, params)
      feed_response = feed.timeline

      expect(feed_response.timeline).to eq expected[:timeline]
      expect(feed_response.status).to eq expected[:status]
      expect(feed_response.pagination).to eq expected[:pagination]
    end

    it 'can get the twitter feed' do
      body = File.read('./spec/support/twitter_responses/timeline_response_count_5.json')
      user = create_user
      create_twitter_account(user)

      stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json?count=5').
        to_return(status: 200, body: body)

      expected = {
        timeline: TIMELINE_2.map do |post|
          post[:created_at] = "#{Time.parse(post[:created_at]).to_i}"
          post[:provider] = 'twitter'
          post.stringify_keys
        end,
        status: {instagram: 204, twitter: 200, facebook: 204},
        pagination: {twitter: Oj.load(body).last['id'].to_s}
      }

      feed = Feed.new(user)
      feed_response = feed.timeline

      expect(feed_response.timeline).to eq expected[:timeline]
      expect(feed_response.status).to eq expected[:status]
      expect(feed_response.pagination).to eq expected[:pagination]
    end

    it 'can get the twitter feed with pagination' do
      body = File.read('./spec/support/twitter_responses/timeline_response_count_5.json')

      stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json?count=26&max_id=462323298248843264').
        to_return(status: 200, body: body)

      expected_timeline = TIMELINE_3.map do |post|
        post[:created_at] = "#{Time.parse(post[:created_at]).to_i}"
        post[:provider] = 'twitter'
        post.stringify_keys
      end

      expected_timeline.shift

      expected = {
        timeline: expected_timeline,
        status: {instagram: 204, twitter: 200, facebook: 204},
        pagination: {twitter: '462321101763522561'}
      }

      user = create_user
      create_twitter_account(user)

      params = {instagram: 'undefined', twitter: '462323298248843264', facebook: 'undefined'}

      feed = Feed.new(user, params)
      feed_response = feed.timeline

      expect(feed_response.timeline).to eq expected[:timeline]
      expect(feed_response.status).to eq expected[:status]
      expect(feed_response.pagination).to eq expected[:pagination]
    end

    it 'can get the Facebook feed' do
      body = File.read('./spec/support/facebook_responses/timeline_response_count_2.json')
      stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
        to_return(status: 200, body: body)
      user = create_user
      create_facebook_account(user)

      expected_timeline = File.read('./spec/support/facebook_responses/time_formatted_timeline_response_count_2.json')

      expected = {
        timeline: Oj.load(expected_timeline),
        status: {instagram: 204, twitter: 204, facebook: 200},
        pagination: {facebook: '1407764111'}
      }

      feed = Feed.new(user)
      feed_response = feed.timeline

      expect(feed_response.timeline).to eq expected[:timeline]
      expect(feed_response.status).to eq expected[:status]
      expect(feed_response.pagination).to eq expected[:pagination]
    end

    it 'can get the facebook feed with pagination' do
      body = File.read('./spec/support/facebook_responses/timeline_response_count_3.json')
      stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=25&until=1407764111').
        to_return(status: 200, body: body)

      user = create_user
      create_facebook_account(user)

      expected_timeline = File.read('./spec/support/facebook_responses/time_formatted_timeline_response_count_3.json')

      expected = {
        timeline: Oj.load(expected_timeline)['data'],
        status: {instagram: 204, twitter: 204, facebook: 200},
        pagination: {facebook: '1407746831'}
      }

      params = {instagram: 'undefined', twitter: 'undefined', facebook: '1407764111'}

      feed = Feed.new(user, params)
      feed_response = feed.timeline

      expect(feed_response.timeline).to eq expected[:timeline]
      expect(feed_response.status).to eq expected[:status]
      expect(feed_response.pagination).to eq expected[:pagination]
    end
  end
end