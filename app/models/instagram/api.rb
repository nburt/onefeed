module Instagram
  class Api < ApplicationController

    def initialize(user)
      @user = user
    end

    def feed(max_id = nil)
      token = @user.accounts.find_by(provider: "instagram").access_token
      if max_id.nil?
        Typhoeus.get("#{base_url(token)}&count=5")
      else
        Typhoeus.get("#{base_url(token)}&count=25&max_id=#{max_id}")
      end
    end

    private

    def base_url(token)
      "https://api.instagram.com/v1/users/self/feed?access_token=#{token}"
    end

  end
end