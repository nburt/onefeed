module Api
  class FeedController < ApplicationController

    def index
      instagram_api = Instagram::Api.new(current_user)
      response = instagram_api.feed(params[:instagram])
      render json: response.body, status: response.code
    end

  end
end