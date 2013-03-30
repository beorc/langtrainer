require "spec_helper"

describe UserMailer do

  describe 'token authentication' do
    before(:each) do
      @user = User.find_by_email('beorc@httplab.ru') || FactoryGirl.create(:user_with_email)
      @email = UserMailer.send_token({auth_token: @user.authentication_token},
                                     @user.email,
                                     I18n.locale)
    end

    it "should generate proper message" do
      @email.should have_subject(I18n.t('mailer.token_authentication.subject'))
      url = root_url(auth_token: @user.authentication_token, host: 'langtrainer.dev', locale: I18n.locale)
      @email.should have_body_text(url)
    end

    it "should deliver successfully" do
      lambda { @email.deliver }.should_not raise_error
    end

    describe "and delivered" do
      it "should be added to the delivery queue" do
        lambda { @email.deliver! }.should change(ActionMailer::Base.deliveries,:size).by(1)
      end
    end
  end

  describe 'email confirmation' do
    before(:each) do
      @user = User.find_by_email('beorc@httplab.ru') || FactoryGirl.create(:user_with_email)
      @email_confirmation = FactoryGirl.create(:email_confirmation, user: @user)
      @email = UserMailer.send_email_confirmation(@email_confirmation.token,
                                                  @email_confirmation.new_email,
                                                  I18n.locale)
    end

    it "should generate proper message" do
      @email.should have_subject(I18n.t('mailer.email_confirmation.subject'))
      url = confirm_email_url(email_token: @email_confirmation.token, host: 'langtrainer.dev', locale: I18n.locale)
      @email.should have_body_text(url)
    end

    it "should deliver successfully" do
      lambda { @email.deliver }.should_not raise_error
    end

    describe "and delivered" do
      it "should be added to the delivery queue" do
        lambda { @email.deliver! }.should change(ActionMailer::Base.deliveries,:size).by(1)
      end
    end
  end
end
