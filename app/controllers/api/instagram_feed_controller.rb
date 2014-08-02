module Api
  class InstagramFeedController < ApplicationController
    def initial_request
      instagram_api = Instagram::Api.new(current_user)
      response = instagram_api.initial_feed
      render json: response.body, status: response.code
    end
  end
end