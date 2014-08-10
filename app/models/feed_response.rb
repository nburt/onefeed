class FeedResponse
  def initialize(instagram_response, twitter_response)
    @instagram_response = instagram_response
    @twitter_response = twitter_response
  end

  def timeline
    converted_tweets = []
    converted_instagram = []

    if !@twitter_response.body.empty?
      converted_tweets = @twitter_response.body.map { |tweet| convert_tweet(tweet) }
    end

    if !instagram_body.empty? && @instagram_response.code == 200
      converted_instagram = instagram_body["data"].map { |post| convert_instagram_post(post) }
    end

    converted_instagram.concat(converted_tweets).sort_by { |post| post["created_at"] }.reverse
  end

  def status
    {
      instagram: @instagram_response.code,
      twitter: @twitter_response.code
    }
  end

  def pagination
    hash = {}
    if !@instagram_body.empty? && @instagram_response.code != 400
      hash[:instagram] = @instagram_body["pagination"]["next_max_id"]
    end
    hash[:twitter] = @twitter_response.body.last.id.to_s if @twitter_response.body.last
    hash
  end

  private

  def instagram_body
    if !@instagram_response.body.empty?
      @instagram_body ||= Oj.load(@instagram_response.body)
    else
      @instagram_body ||= []
    end
  end

  def convert_instagram_post(post)
    post["created_at"] = "#{post["created_time"].to_i}"
    post.delete("created_time")
    post["provider"] = "instagram"
    post
  end

  def convert_tweet(tweet)
    hash = tweet.to_h.stringify_keys
    hash["created_at"] = "#{tweet.created_at.to_i}"
    hash["provider"] = "twitter"
    hash
  end
end