class FeedResponse
  def initialize(instagram_response, twitter_response, facebook_response)
    @instagram_response = instagram_response
    @twitter_response = twitter_response
    @facebook_response = facebook_response
  end

  def timeline
    converted_tweets = []
    converted_instagram = []
    converted_facebook = []

    if !@twitter_response.body.empty?
      converted_tweets = @twitter_response.body.map { |tweet| convert_tweet(tweet) }
    end

    if !instagram_body.empty? && @instagram_response.code == 200
      converted_instagram = instagram_body["data"].map { |post| convert_instagram_post(post) }
    end

    if !facebook_body.empty? && @facebook_response.code == 200
      converted_facebook = facebook_body["data"].map { |post| convert_facebook_post(post) }
    end

    converted_instagram.concat(converted_tweets).concat(converted_facebook).sort_by { |post| post["created_at"] }.reverse
  end

  def status
    {
      instagram: @instagram_response.code,
      twitter: @twitter_response.code,
      facebook: @facebook_response.code
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

  def convert_tweet(tweet)
    hash = tweet.to_h.stringify_keys
    hash["created_at"] = "#{tweet.created_at.to_i}"
    hash["provider"] = "twitter"
    hash
  end

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

  def facebook_body
    if !@facebook_response.body.empty?
      @facebook_body ||= Oj.load(@facebook_response.body)
    else
      @facebook_body ||= []
    end
  end

  def convert_facebook_post(post)
    post["created_at"] = "#{Time.parse(post["created_time"]).to_i}"
    post.delete("created_time")
    post["provider"] = "facebook"
    post
  end

end