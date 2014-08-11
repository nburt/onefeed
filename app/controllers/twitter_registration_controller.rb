class TwitterRegistrationController < ApplicationController

  def create
    begin
      Account.update_or_create_with_omniauth(current_user, request.env["omniauth.auth"])
    rescue ActiveRecord::RecordInvalid
      flash[:registration_failure] = "Registration with Twitter failed, please try again."
    end
    redirect_to feed_path
  end

end