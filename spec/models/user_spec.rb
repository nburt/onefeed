require 'rails_helper'

describe User do
  describe "#validations" do
    let!(:user) {User.new(first_name: 'Nathanael', last_name: 'Burt', email: 'nate@example.com', password: 'password')}

    it 'must have a valid first name' do
      expect(user).to be_valid
      user.first_name = nil
      expect(user).to_not be_valid
    end

    it 'must have a last name' do
      user.last_name = nil
      expect(user).to_not be_valid
    end

    it 'must have an email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'must have a unique email' do
      User.create!(first_name: 'Nathanael', last_name: 'Burt', email: 'nate@example.com', password: 'password')
      expect(user).to_not be_valid
    end

    it 'must have a valid email' do
      user.email = 'nate'
      expect(user).to_not be_valid
      user.email = 'nate@example.com'
      expect(user).to be_valid
      user.email = 'nate@example'
      expect(user).to_not be_valid
      user.email = 'nate@example.com'
      expect(user).to be_valid
      user.email = 'nate.com'
      expect(user).to_not be_valid
    end
  end

  describe "#auth_token" do
    it 'assigns an auth token to a user on create' do
      user = User.create!(first_name: 'Nathanael', last_name: 'Burt', email: 'nate@example.com', password: 'password')
      expect(user.auth_token).to_not be_nil
    end
  end
end