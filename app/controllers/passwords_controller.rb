class PasswordsController < ApplicationController

  def new
    @user = User.new
    render 'new', layout: 'login'
  end

  def send_email
    user_email = params[:user][:email]
    user = User.find_by(email: user_email)
    if user
      user_information = Rails.application.message_verifier(:user_information).generate([user.id, Time.now + 1.days])
      PasswordMailer.reset_password(user, user_information).deliver
    else
      PasswordMailer.wrong_email(user_email).deliver
    end

    flash[:reset_password_email_sent] = "An email has been sent to #{user_email} with further instructions on how to reset your password."
    redirect_to new_session_path
  end

  def edit
    @user_information = params[:user_information]
    user_id, expiration_date = Rails.application.message_verifier(:user_information).verify(@user_information)
    @user = User.find(user_id)

    if Time.now > expiration_date
      flash[:expired_token] = "Your password reset token has expired. Please request a new one by filling out the form below."
      redirect_to forgot_password_path
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    render_404
  end

  def update
    @user_information = params[:user][:user_information]
    user_id, _ = Rails.application.message_verifier(:user_information).verify(@user_information)
    @user = User.find(user_id)
    if @user.update_attributes(secure_params)
      flash[:updated_password] = "Your password has been updated. You may now sign in with your email and updated password."
      redirect_to new_session_path
    else
      flash[:passwords_dont_match] = "Your password and password confirmation do not match."
      render 'edit'
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    render_404
  end

  private

  def secure_params
    params.require(:user).permit(:password.presence, :password_confirmation.presence)
  end

  def render_404
    render "public/404", layout: false
  end

end