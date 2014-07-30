require 'rails_helper'

feature 'registration and login' do
  context "visiting the homepage, registering, and logging in" do
    it 'a user can visit the homepage and register, and then logout and log back in' do
      visit '/'
      within '.registration-container' do
        fill_in 'user[first_name]', with: 'Nathanael'
        fill_in 'user[last_name]', with: 'Burt'
        fill_in 'user[email]', with: 'nate@example.com'
        fill_in 'user[password]', with: 'password'
        click_button 'Register'
      end

      click_link 'Logout'

      click_link 'Login'

      fill_in 'session[email]', with: 'nate@example.com'
      fill_in 'session[password]', with: 'password'
      click_button 'Login'

      expect(page).to have_content 'Logout'
      expect(current_path).to eq '/feed'
    end

    scenario 'a user cannot login with incorrect credentials' do
      create_user
      visit '/login'

      fill_in 'session[email]', with: 'nate@example.com'
      fill_in 'session[password]', with: 'incorrect_password'
      click_button 'Login'

      expect(page).to have_content 'Invalid email or password'

      fill_in 'session[email]', with: 'incorrect_email@example.com'
      fill_in 'session[password]', with: 'password'
      click_button 'Login'

      expect(page).to have_content 'Invalid email or password'
    end

    scenario 'a user is redirected to /feed if they visit the root path while logged in' do
      visit '/'
      within '.registration-container' do
        fill_in 'user[first_name]', with: 'Nathanael'
        fill_in 'user[last_name]', with: 'Burt'
        fill_in 'user[email]', with: 'nate@example.com'
        fill_in 'user[password]', with: 'password'
        click_button 'Register'
      end

      visit '/'
      expect(page).to_not have_content 'Register'
      expect(page).to_not have_content 'Sign Up with OneFeed'
      expect(page).to have_content 'Logout'
    end

    scenario 'a user cannot visit /feed if they are not logged in' do
      visit '/feed'
      expect(page).to_not have_content 'Logout'
      expect(page).to have_content 'Register with OneFeed'
    end
  end

  context "resetting a forgotten password" do
    scenario 'a user can reset their password' do
      create_user
      visit '/login'

      emails_sent = ActionMailer::Base.deliveries.length

      click_link 'Forgot Your Password?'
      within 'main' do
        fill_in 'user[email]', :with => 'nate@example.com'
        click_button 'Send Email'
      end

      expect(ActionMailer::Base.deliveries.length).to eq(emails_sent + 1)
      expect(page).to have_content 'An email has been sent to nate@example.com with
                                    further instructions on how to reset your password.'

      email_message = ActionMailer::Base.deliveries.last.body.parts[1].body.raw_source

      @doc = Nokogiri::HTML(email_message)

      result = @doc.xpath("//a").first['href']

      visit result

      within 'main' do
        fill_in 'user[password]', :with => 'password2'
        fill_in 'user[password_confirmation]', :with => 'password2'
        click_button 'Update Password'
      end

      expect(page).to have_content 'Your password has been updated. You may now sign in with your email and updated password.'

      fill_in 'session[email]', :with => 'nate@example.com'
      fill_in 'session[password]', :with => 'password2'
      click_button 'Login'

      expect(page).to have_content 'Logout'
    end

    scenario 'a user tries to reset their password with an email address that does not exist' do
      create_user
      visit '/login'

      emails_sent = ActionMailer::Base.deliveries.length

      click_link 'Forgot Your Password?'
      within 'main' do
        fill_in 'user[email]', :with => 'burt@example.com'
        click_button 'Send Email'
      end

      expect(ActionMailer::Base.deliveries.length).to eq(emails_sent + 1)
      expect(page).to have_content 'An email has been sent to burt@example.com with
                                    further instructions on how to reset your password.'

      email_message = ActionMailer::Base.deliveries.last.body.parts[1].body.raw_source

      @doc = Nokogiri::HTML(email_message)

      expect(email_message).to include 'Hi burt@example.com, you are receiving this email because you (or someone else)'
    end

    scenario 'a user tries to reset their password but their token has expired' do
      user = create_user
      user_information = Rails.application.message_verifier(:user_information).generate([user.id, 1.day.ago])
      PasswordMailer.reset_password(user, user_information).deliver

      email_message = ActionMailer::Base.deliveries.last.body.parts[1].body.raw_source

      @doc = Nokogiri::HTML(email_message)

      result = @doc.xpath("//a").first['href']

      visit result

      expect(page).to have_content 'Your password reset token has expired. Please request a new one by filling out the form below.'
      expect(current_url).to eq ("http://localhost:3000/passwords/reset")
    end

    scenario 'user cannot visit the /passwords/edit page if they do not have a message param with the token' do
      visit '/passwords/edit'
      expect(page).to have_content "The page you were looking for doesn't exist."
    end

    scenario 'a user enters a password and password confirmation that do not match' do
      user = create_user
      user_information = Rails.application.message_verifier(:user_information).generate([user.id, Time.now + 1.days])
      PasswordMailer.reset_password(user, user_information).deliver

      email_message = ActionMailer::Base.deliveries.last.body.parts[1].body.raw_source

      @doc = Nokogiri::HTML(email_message)

      result = @doc.xpath("//a").first['href']

      visit result

      within 'main' do
        fill_in 'user[password]', :with => 'password1'
        fill_in 'user[password_confirmation]', :with => 'password2'
        click_button 'Update Password'
      end

      expect(page).to have_content 'Your password and password confirmation do not match.'
    end

  end
end