class FacebookRegistrationController < ApplicationController

  def create
    begin
      Account.update_or_create_with_omniauth(current_user, request.env["omniauth.auth"])
      flash[:facebook_success] = "You have successfully logged in with Facebook!"
    rescue ActiveRecord::RecordInvalid
      flash[:registration_failure] = "Registration with Facebook failed, please try again."
    end
    redirect_to feed_path
  end

end