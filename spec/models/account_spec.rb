require 'rails_helper'

describe Account do
  describe "creating and updating an account" do
    it 'can create an account for a user' do
      user = create_user
      auth = {
        "provider" => "instagram",
        "uid" => "1234",
        "credentials" => {
          "token" => "mock_token"
        }
      }

      expect { Account.update_or_create_with_omniauth(user, auth) }.to change { Account.count }.by(1)
      account = Account.last
      expect(account.provider).to eq "instagram"
      expect(account.uid).to eq "1234"
      expect(account.access_token).to eq "mock_token"
      expect(account.user_id).to eq user.id
    end

    it 'can update an account for a user' do
      user = create_user
      auth = {
        "provider" => "instagram",
        "uid" => "1234",
        "credentials" => {
          "token" => "mock_token"
        }
      }
      account = Account.update_or_create_with_omniauth(user, auth)

      auth2 = {
        "provider" => "instagram",
        "uid" => "1234",
        "credentials" => {
          "token" => "mock_token_2"
        }
      }

      expect { Account.update_or_create_with_omniauth(user, auth2) }.to_not change { Account.count }
      expect(account.reload.access_token).to eq "mock_token_2"
    end

    it 'raises an exception if the save fails' do
      user = create_user
      auth = {
        "uid" => "1234",
        "credentials" => {
          "token" => "mock_token"
        }
      }
      expect{Account.update_or_create_with_omniauth(user, auth)}.to raise_error ActiveRecord::RecordInvalid
    end

    it 'can create an account for a twitter' do
      user = create_user
      auth = {
        "provider" => "twitter",
        "uid" => "1234",
        "credentials" => {
          "token" => "mock_token",
          "secret" => "mock_token_secret"
        }
      }

      account = Account.update_or_create_with_omniauth(user, auth)

      expect(account.access_token_secret).to eq "mock_token_secret"
      expect(account.access_token).to eq "mock_token"
    end
  end

  describe "validations" do
    let(:account) {Account.new(provider: "instagram", uid: "1234", access_token: "mock_token", user_id: 1)}

    it 'must have a provider' do
      expect(account).to be_valid
      account.provider = nil
      expect(account).to_not be_valid
    end

    it 'must have a uid' do
      expect(account).to be_valid
      account.uid = nil
      expect(account).to_not be_valid
    end

    it 'must have an access_token' do
      expect(account).to be_valid
      account.access_token = nil
      expect(account).to_not be_valid
    end

    it 'must have a user_id' do
      expect(account).to be_valid
      account.user_id = nil
      expect(account).to_not be_valid
    end
  end
end