require 'rails_helper'

describe SessionsController do
  describe "persistent sessions" do
    it 'a user is assigned a cookie if they select remember me' do
      user = create_user
      get :create, {:session => {:email => "nate@example.com", :password => "password", :remember_me => "1"}}
      expect(cookies.signed["auth_token"]).to eq user.auth_token
      expect(session[:user_id]).to eq user.id
    end

    it 'a user is not assigned a cookie if they select remember me' do
      user = create_user
      get :create, {:session => {:email => "nate@example.com", :password => "password", :remember_me => "0"}}
      expect(cookies.signed["auth_token"]).to eq nil
      expect(session[:user_id]).to eq user.id
    end

    it 'clears out the users cookie and session when they logout' do
      create_user
      get :create, {:session => {:email => "nate@example.com", :password => "password", :remember_me => "1"}}
      get :destroy
      expect(cookies.signed["auth_token"]).to eq nil
      expect(session[:user_id]).to eq nil
    end
  end
end
