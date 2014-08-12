module Facebook
  class Api

    def initialize(user)
      @user = user
    end

    def feed(pagination = nil)
      account = @user.accounts.find_by(provider: "facebook")
      if account
        make_feed_request(account, pagination)
      else
        NullResponse.new
      end
    end

    private

    def make_feed_request(account, pagination)
      if pagination
        Typhoeus.get("https://graph.facebook.com/v2.0/me/home?limit=25&access_token=#{account.access_token}&until=#{pagination}")
      else
        Typhoeus.get("https://graph.facebook.com/v2.0/me/home?limit=5&access_token=#{account.access_token}")
      end
    end

  end
end