module Instagram
  class Api < ApplicationController

    def initialize(user)
      @user = user
    end

    def initial_feed
      user_account = @user.accounts.find_by(provider: "instagram")
      token = user_account.access_token
      Typhoeus.get("https://api.instagram.com/v1/users/self/feed?access_token=#{token}&count=5")
    end

  end
end