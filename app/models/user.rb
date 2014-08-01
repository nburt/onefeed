class User < ActiveRecord::Base
  before_create { generate_token(:auth_token) }

  has_secure_password

  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email
  validate :email_must_be_valid

  private

  def generate_token(column)
    self[column] = SecureRandom.urlsafe_base64
    while User.exists?(column => self[column])
      self[column] = SecureRandom.urlsafe_base64
    end
  end

  def email_must_be_valid
    if email != nil
      if !email.match /.*@.*\..*/
        errors.add(:base, "Must be a valid email address")
      end
    end
  end
end