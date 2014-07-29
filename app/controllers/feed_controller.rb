class FeedController < ApplicationController

  def index
    if !logged_in?
      redirect_to root_path
    end
  end

end