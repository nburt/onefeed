module Api
  class FeedController < ApplicationController

    def index
      feed = Feed.new(current_user, params)
      response = feed.timeline
      http_status_code = http_status_code(response.status)
      render json: {
        timeline: response.timeline,
        status: response.status,
        pagination: response.pagination
      }, status: http_status_code
    end

    private

    def http_status_code(response_status)
      if response_status.values.include?(200)
        200
      else
        400
      end
    end

  end
end
