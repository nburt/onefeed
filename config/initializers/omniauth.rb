Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, ENV['INSTAGRAM_CLIENT_ID'], ENV['INSTAGRAM_CLIENT_SECRET'], :scope => 'likes comments relationships'
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET']
end