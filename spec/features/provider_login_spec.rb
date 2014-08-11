require 'rails_helper'

feature 'logging in with providers' do
  scenario 'a user will see an error message if registration with Instagram fails' do
    mock_auth_invalid_hash
    user = create_user
    login_user(user)
    click_link 'My Account'
    find(:xpath, "//a[contains(@href,'/auth/instagram')]").click
    expect(page).to have_content 'Registration with Instagram failed, please try again.'
  end

  scenario 'a user will see an error message if registration with Twitter fails' do
    mock_auth_invalid_hash
    user = create_user
    login_user(user)
    click_link 'My Account'
    find(:xpath, "//a[contains(@href,'/auth/twitter')]").click
    expect(page).to have_content 'Registration with Twitter failed, please try again.'
  end

  scenario 'a user can login with Facebook' do
    mock_auth_hash
    user = create_user
    login_user(user)
    click_link 'My Account'
    find(:xpath, "//a[contains(@href,'/auth/facebook')]").click
    expect(page).to have_content 'You have successfully logged in with Facebook!'
  end

  scenario 'a user will see an error message if registration with Facebook fails' do
    mock_auth_invalid_hash
    user = create_user
    login_user(user)
    click_link 'My Account'
    find(:xpath, "//a[contains(@href,'/auth/facebook')]").click
    expect(page).to have_content 'Registration with Facebook failed, please try again.'
  end
end