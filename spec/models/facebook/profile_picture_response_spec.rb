require 'rails_helper'

describe Facebook::ProfilePictureResponse do
  it 'takes a typhoeus facebook profile picture response and returns the url' do
    body = {
      'data' => {
        'url' => 'https=>//fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c10.0.50.50/p50x50/544089_10202552316910864_1418490882_s.jpg',
        'is_silhouette' => false
      }
    }.to_json

    stub_request(:get, 'https://graph.facebook.com/10203694030092980/picture?redirect=false').
      to_return(:body => body)

    response = Typhoeus.get('https://graph.facebook.com/10203694030092980/picture?redirect=false')

    profile_picture_response = Facebook::ProfilePictureResponse.new(response)
    expect(profile_picture_response.url).to eq 'https=>//fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c10.0.50.50/p50x50/544089_10202552316910864_1418490882_s.jpg'
  end
end