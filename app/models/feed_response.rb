class FeedResponse
  def initialize(instagram_response)
    @instagram_response = instagram_response
  end

  def timeline
    Oj.load(@instagram_response.body)
  end

  def status
    {instagram: @instagram_response.code}
  end
end