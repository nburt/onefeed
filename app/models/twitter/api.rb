module Twitter
  class Api

    def initialize(user)
      @user = user
    end

    def feed(pagination = nil)
      account = @user.accounts.find_by(provider: "twitter")
      if account
        client = configure_client(account)
        body = client.home_timeline(count: 5)
        twitter_feed_response(body)
      else
        NullResponse.new
      end
    end

    private

    def twitter_feed_response(body)
      Struct.new(:body, :code).new(body, 200)
    end

    def configure_client(account)
      Twitter::REST::Client.new do |config|
        config.consumer_key = ENV["TWITTER_API_KEY"]
        config.consumer_secret = ENV["TWITTER_API_SECRET"]
        config.access_token = account.access_token
        config.access_token_secret = account.access_token_secret
      end
    end

  end
end