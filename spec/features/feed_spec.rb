require 'rails_helper'

feature 'streaming a users feed', js: true do
  scenario 'when a user logs in with Instagram they will see their feed at /feed' do
    body = File.read('./spec/support/instagram_responses/timeline_response_count_5.json')
    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5').
      to_return(status: 200, body: body)

    mock_auth_hash
    user = create_user
    login_user(user)
    click_link 'My Account'
    find('.network-logo-link').click
    expect(page).to have_content 'Unicorns do exist! #magic #unicorns #denvercountyfair'
    expect(page).to have_content 'Climbing up the steps of #SaintJosephsOratory'
  end
end