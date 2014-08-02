def create_instagram_account(user)
  Account.create!(
    user_id: user.id,
    provider: "instagram",
    uid: "1234",
    access_token: "mock_token"
  )
end
