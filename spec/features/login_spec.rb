require 'rails_helper'

feature 'visiting homepage and logging in' do
  scenario 'a user can visit the homepage and register, and then logout and log back in' do
    visit '/'
    within '#registration-container' do
      fill_in 'user[first_name]', with: 'Nathanael'
      fill_in 'user[last_name]', with: 'Burt'
      fill_in 'user[email]', with: 'nate@example.com'
      fill_in 'user[password]', with: 'password'
      click_button 'Register'
    end

    expect(page).to have_content 'Welcome to OneFeed'
    click_link 'Logout'

    within 'header' do
      fill_in 'user[email]', with: 'nate@example.com'
      fill_in 'user[password]', with: 'password'
      click_button 'Login'
    end

    expect(page).to have_content 'Welcome to OneFeed'
  end

  scenario 'a user cannot login with incorrect credentials' do
    visit '/'
    within '#registration-container' do
      fill_in 'user[first_name]', with: 'Nathanael'
      fill_in 'user[last_name]', with: 'Burt'
      fill_in 'user[email]', with: 'nate@example.com'
      fill_in 'user[password]', with: 'password'
      click_button 'Register'
    end

    click_link 'Logout'

    within 'header' do
      fill_in 'user[email]', with: 'nate@example.com'
      fill_in 'user[password]', with: 'passwords'
      click_button 'Login'
    end

    expect(page).to have_content 'Invalid email or password'

    within 'header' do
      fill_in 'user[email]', with: 'nate@examples.com'
      fill_in 'user[password]', with: 'password'
      click_button 'Login'
    end

    expect(page).to have_content 'Invalid email or password'
  end
end