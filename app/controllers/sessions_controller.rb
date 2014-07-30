class SessionsController < ApplicationController

  def new
    render 'new', layout: 'login'
  end

  def create
    user = User.find_by(:email => params[:session][:email])
    if user.present? && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to feed_path
    else
      session[:user_id] = nil
      flash[:login_error] = "Invalid email or password"
      render 'new', layout: 'login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

end