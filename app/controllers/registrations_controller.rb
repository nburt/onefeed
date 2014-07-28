class RegistrationsController < ApplicationController

  def create
    @user = User.new(secure_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to feed_path
    else
      render 'welcome/index'
    end
  end

  private

  def secure_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

end