module Api
  class ProfilePicturesController < ApplicationController

    def show
      response = Facebook::ProfilePicture.fetch_profile_picture_for(params[:user_id])
      render json: {url: response.url}
    end

  end
end