class WelcomeController < ApplicationController

  def index
    if logged_in?
      redirect_to feed_path
    else
      @user = User.new
      render 'index', layout: 'login'
    end
  end

end