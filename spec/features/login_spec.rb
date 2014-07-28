require 'rails_helper'

feature 'visiting homepage and logging in' do
  scenario 'a user can visit the homepage and register' do
    visit '/'
    fill_in 'user[first_name]', with: 'Nathanael'
    fill_in 'user[last_name]', with: 'Burt'
    fill_in 'user[email]', with: 'nate@example.com'
    fill_in 'user[password]', with: 'password'
    click_button 'Sign Up'
    expect(page).to have_content 'Welcome to OneFeed'
  end
end