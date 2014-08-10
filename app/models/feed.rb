class Feed
  def initialize(user, params = {instagram: nil})
    @user = user
    @instagram_pagination = params[:instagram]
  end

  def timeline
    FeedResponse.new(fetch_instagram_timeline, fetch_twitter_timeline)
  end

  private

  def fetch_twitter_timeline
    twitter_api = Twitter::Api.new(@user)
    twitter_api.feed(@twitter_pagination)
  end

  def fetch_instagram_timeline
    instagram_api = Instagram::Api.new(@user)
    instagram_api.feed(@instagram_pagination)
  end
end
