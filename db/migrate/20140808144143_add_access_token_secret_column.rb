class AddAccessTokenSecretColumn < ActiveRecord::Migration
  def change
    add_column :accounts, :access_token_secret, :string
  end
end
