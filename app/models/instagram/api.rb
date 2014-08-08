module Instagram
  class Api

    def initialize(user)
      @user = user
    end

    def feed(max_id = nil)
      account = @user.accounts.find_by(provider: "instagram")
      if account
        make_feed_request(account, max_id)
      else
        NullResponse.new
      end
    end

    private

    def make_feed_request(account, max_id)
      if max_id.nil?
        Typhoeus.get("#{base_url(account.access_token)}&count=5")
      else
        Typhoeus.get("#{base_url(account.access_token)}&count=25&max_id=#{max_id}")
      end
    end

    def base_url(token)
      "https://api.instagram.com/v1/users/self/feed?access_token=#{token}"
    end

  end
end