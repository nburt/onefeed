class Account < ActiveRecord::Base

  validates_presence_of :provider, :uid, :access_token, :user_id
  belongs_to :user

  def self.update_or_create_with_omniauth(user, auth)
    account = where(provider: auth["provider"]).first_or_initialize
    account.provider = auth["provider"]
    account.uid = auth["uid"]
    account.access_token = auth["credentials"]["token"]
    account.access_token_secret = auth["credentials"]["secret"]
    account.user_id = user.id
    account.save!
    account
  end

end