require 'rails_helper'

describe PasswordMailer do
  describe "Resetting a password" do
    context "user supplies correct email" do

      let(:user) { create_user }
      let(:message) { ActiveSupport::MessageVerifier.new(SecureRandom.urlsafe_base64).generate([user.id, Time.now + 1.days]) }
      let(:reset_password) { PasswordMailer.reset_password(user, message) }

      it 'sends an email to reset a users password' do
        email_text = reset_password.text_part.body
        expect(email_text).to include "#{user.first_name}, you are receiving this email because you requested a password reset. To reset your password, please visit the link below."
      end

      it 'is sent from onefeed no_reply' do
        expect(reset_password.from).to eq ['no_reply@onefeed.com']
      end

      it 'is sent to the correct email address' do
        expect(reset_password.to).to eq [user.email]
      end

      it 'has the correct subject line' do
        expect(reset_password.subject).to eq 'OneFeed password reset request'
      end
    end

    context "user supplies wrong email" do
      let(:wrong_email) { PasswordMailer.wrong_email('foo@bar.com') }

      it 'sends an email if the given email does not match any emails in the database' do
        email_text = wrong_email.text_part.body.to_s
        expect(email_text).to include "Hi foo@bar.com, you are receiving this email because you (or someone else) entered this email address when requesting a password reset."
      end

      it 'is sent from onefeed no_reply' do
        expect(wrong_email.from).to eq ['no_reply@onefeed.com']
      end

      it 'is sent to the user' do
        expect(wrong_email.to).to eq ['foo@bar.com']
      end

      it 'has the correct subject line' do
        expect(wrong_email.subject).to eq 'OneFeed password reset attempt'
      end
    end
  end
end