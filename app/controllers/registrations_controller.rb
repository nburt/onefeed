class RegistrationsController < ApplicationController

  def create
    @user = User.new(secure_params)
    if @user.save
      cookies.signed[:auth_token] = @user.auth_token
      redirect_to feed_path
    else
      render 'welcome/index', layout: 'login'
    end
  end

  private

  def secure_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

end