module Twitter
  class Api

    def initialize(user)
      @user = user
    end

    def feed(pagination = nil)
      account = @user.accounts.find_by(provider: "twitter")
      if account
        fetch_home_timeline(account, pagination)
      else
        NullResponse.new
      end
    end

    private

    def fetch_home_timeline(account, pagination)
      begin
        client = configure_client(account)
        if pagination
          body = client.home_timeline(count: 26, max_id: pagination)
          body.shift
        else
          body = client.home_timeline(count: 5)
        end
        twitter_feed_response(body)
      rescue Twitter::Error::Unauthorized
        Struct.new(:body, :code).new([], 401)
      end
    end

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