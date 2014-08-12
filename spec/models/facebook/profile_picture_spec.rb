require 'rails_helper'

describe Facebook::ProfilePicture do
  it 'makes handles making a request for a users profile picture' do
    body = {
      'data' => {
        'url' => 'https=>//fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c10.0.50.50/p50x50/544089_10202552316910864_1418490882_s.jpg',
        'is_silhouette' => false
      }
    }.to_json

    stub_request(:get, 'https://graph.facebook.com/10203694030092980/picture?redirect=false').
      to_return(:body => body)

    response = Facebook::ProfilePicture.fetch_profile_picture_for('10203694030092980')
    expect(response.url).to eq 'https=>//fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c10.0.50.50/p50x50/544089_10202552316910864_1418490882_s.jpg'
  end
end
