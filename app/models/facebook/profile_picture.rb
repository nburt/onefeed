module Facebook
  class ProfilePicture

    def self.fetch_profile_picture_for(user_id)
      Facebook::ProfilePictureResponse.new(Typhoeus.get("https://graph.facebook.com/#{user_id}/picture?redirect=false"))
    end

  end
end