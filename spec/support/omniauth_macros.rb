module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:instagram] = {
      'provider' => 'instagram',
      'uid' => '123546',
      'info' => {
        'name' => 'mockuser',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token'
      }
    }

    OmniAuth.config.mock_auth[:twitter] = {
      'provider' => 'twitter',
      'uid' => '123545',
      'info' => {
        'name' => 'mockuser',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      },
    }

    OmniAuth.config.mock_auth[:facebook] = {
      'provider' => 'facebook',
      'uid' => '123545',
      'credentials' => {
        'token' => 'mock_token',
        'expires_at' => Time.now.to_i,
      },
    }
  end

  def mock_auth_invalid_hash
    OmniAuth.config.mock_auth[:instagram] = {
      'provider' => 'instagram',
      'info' => {
        'name' => 'mockuser',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token'
      }
    }

    OmniAuth.config.mock_auth[:twitter] = {
      'provider' => 'twitter',
      'info' => {
        'name' => 'mockuser',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token',
      },
    }
  end
end