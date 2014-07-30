class WelcomeController < ApplicationController

  def index
    if logged_in?
      redirect_to feed_path
    else
      @user = User.new
      render 'welcome/index', layout: 'homepage'
    end
  end

end