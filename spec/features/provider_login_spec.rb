require 'rails_helper'

feature 'logging in with providers' do
  scenario 'a user will see a message if registration with Instagram fails' do
    mock_auth_invalid_hash
    user = create_user
    login_user(user)
    click_link 'My Account'
    find('.network-logo-link').click
    expect(page).to have_content 'Registration with Instagram failed, please try again'
    expect(page).to_not have_content 'You have successfully logged in with Instagram'
  end
end