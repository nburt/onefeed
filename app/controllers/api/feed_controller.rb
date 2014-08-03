module Api
  class FeedController < ApplicationController

    def create
      instagram_api = Instagram::Api.new(current_user)
      response = instagram_api.initial_feed
      render json: response.body, status: response.code
    end

  end
end