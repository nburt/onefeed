module Facebook
  class Api

    def initialize(user)
      @user = user
    end

    def feed
      account = @user.accounts.find_by(provider: "facebook")
      if account
        Typhoeus.get("https://graph.facebook.com/v2.0/me/home?limit=5&access_token=#{account.access_token}")
      else
        NullResponse.new
      end
    end

  end
end