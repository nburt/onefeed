class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :logged_in?
  before_filter :sign_in_from_cookie

  private

  def sign_in_from_cookie
    user = User.find_by(:auth_token => cookies.signed[:auth_token]) if cookies[:auth_token]
    if user
      self.current_user = user
    end
  end

  def current_user=(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end
end
