module Instagram
  class Api < ApplicationController

    def initialize(user)
      @user = user
    end

    def feed(max_id = nil)
      user_account = @user.accounts.find_by(provider: "instagram")
      token = user_account.access_token
      if max_id.nil?
        Typhoeus.get("https://api.instagram.com/v1/users/self/feed?access_token=#{token}&count=5")
      else
        Typhoeus.get("https://api.instagram.com/v1/users/self/feed?access_token=#{token}&count=25&max_id=#{max_id}")
      end
    end

  end
end