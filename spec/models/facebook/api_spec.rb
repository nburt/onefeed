require 'rails_helper'

describe Facebook::Api do
  it 'can get the latest 5 posts for a user' do
    body = File.read('./spec/support/facebook_responses/timeline_response_count_5.json')
    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
      to_return(status: 200, body: body)
    user = create_user
    create_facebook_account(user)
    facebook_api = Facebook::Api.new(user)
    response = facebook_api.feed
    expect(response.body).to eq body
    expect(response.code).to eq 200
  end

  it 'will return an empty array if the user does not have a facebook account' do
    user = create_user
    facebook_api = Facebook::Api.new(user)
    response = facebook_api.feed
    expect(response.body).to eq []
    expect(response.code).to eq 204
  end

  it 'can get the next range of posts if passed a pagination id' do
    body = File.read('./spec/support/facebook_responses/timeline_response_count_3.json')
    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=25&until=1407764111').
      to_return(status: 200, body: body)
    user = create_user
    create_facebook_account(user)
    facebook_api = Facebook::Api.new(user)
    response = facebook_api.feed('1407764111')
    expect(response.body).to eq body
    expect(response.code).to eq 200
  end

  it 'will return an error if the users account is unauthorized' do
    body = {
      'error' => {
        'message' => 'Invalid OAuth access token.',
        'type' => 'OAuthException',
        'code' => 190
      }
    }.to_json

    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
      to_return(status: 190, body: body)

    user = create_user
    create_facebook_account(user)
    facebook_api = Facebook::Api.new(user)
    response = facebook_api.feed

    expect(response.body).to eq body
    expect(response.code).to eq 190
  end
end