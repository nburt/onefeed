class TwitterRegistrationController < ApplicationController

  def create
    Account.update_or_create_with_omniauth(current_user, request.env["omniauth.auth"])
    flash[:twitter_success] = "You have successfully logged in with Twitter"
    redirect_to feed_path
  end

end