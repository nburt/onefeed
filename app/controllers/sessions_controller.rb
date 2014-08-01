class SessionsController < ApplicationController

  def new
    render 'new', layout: 'login'
  end

  def create
    user = User.find_by(:email => params[:session][:email])
    if user.present? && user.authenticate(params[:session][:password])
      if params[:session][:remember_me].to_i == 1
        cookies.signed[:auth_token] = {:value => user.auth_token, :expires => 30.days.from_now}
      end
      self.current_user = user
      redirect_to feed_path
    else
      cookies.signed[:auth_token] = nil
      flash[:login_error] = "Invalid email or password"
      render 'new', layout: 'login'
    end
  end

  def destroy
    cookies.delete(:auth_token)
    session.destroy
    redirect_to root_url
  end

end