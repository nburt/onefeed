class PasswordMailer < ActionMailer::Base

  default from: "no_reply@onefeed.com"

  def reset_password(user, user_information)
    @user = user
    @user_information = user_information
    mail(to: @user.email, subject: "OneFeed password reset request")
  end

  def wrong_email(email)
    @email = email
    mail(to: @email, subject: "OneFeed password reset attempt")
  end

end
