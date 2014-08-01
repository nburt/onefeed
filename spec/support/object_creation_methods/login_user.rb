def login_user(user)
  visit '/login'
  fill_in 'session[email]', :with => "#{user.email}"
  fill_in 'session[password]', :with => "#{user.password}"
  click_button 'Login'
end