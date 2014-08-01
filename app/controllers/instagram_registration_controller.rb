class InstagramRegistrationController < ApplicationController

  def create
    begin
      Account.update_or_create_with_omniauth(current_user, request.env["omniauth.auth"])
      flash[:registration_success] = "You have successfully logged in with Instagram"
    rescue ActiveRecord::RecordInvalid
      flash[:registration_failure] = "Registration with Instagram failed, please try again"
    end
    redirect_to feed_path
  end

end