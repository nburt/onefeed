def create_instagram_account(user)
  Account.create!(
    user_id: user.id,
    provider: "instagram",
    uid: "1234",
    access_token: "mock_token"
  )
end

def create_twitter_account(user)
  Account.create!(
    user_id: user.id,
    provider: "twitter",
    uid: "1234",
    access_token: "mock_token",
    access_token_secret: "mock_token"
  )
end

def create_facebook_account(user)
  Account.create!(
    user_id: user.id,
    provider: "facebook",
    uid: "1234",
    access_token: "mock_token",
  )
end