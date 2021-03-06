require 'rails_helper'

describe Instagram::Api do
  it 'can get the latest 5 posts for a user' do
    body = File.read("./spec/support/instagram_responses/timeline_response_count_5.json")

    stub_request(:get, "https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5").
      to_return(status: 200, body: body)

    user = create_user
    create_instagram_account(user)
    instagram_api = Instagram::Api.new(user)
    response = instagram_api.feed
    expect(response.body).to eq body
    expect(response.code).to eq 200
  end

  it 'can get the latest 25 posts for a user' do
    body = File.read("./spec/support/instagram_responses/timeline_response_count_25.json")

    stub_request(:get, "https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=25&max_id=778569615424721376_42804963").
      to_return(status: 200, body: body)

    user = create_user
    create_instagram_account(user)
    instagram_api = Instagram::Api.new(user)
    response = instagram_api.feed("778569615424721376_42804963")
    expect(response.body).to eq body
    expect(response.code).to eq 200
  end

  it 'will return an empty array if the user does not have an instagram account' do
    user = create_user
    instagram_api = Instagram::Api.new(user)
    response = instagram_api.feed
    expect(response.body).to eq []
    expect(response.code).to eq 204
  end

  it 'will return a 400 with an error message if the account if unauthorized' do
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
    instagram_api = Instagram::Api.new(user)
    response = instagram_api.feed

    expect(response.body).to eq body
    expect(response.code).to eq 400
  end
end