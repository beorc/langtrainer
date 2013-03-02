class TokenAuthenticationsController < ApplicationController
  if Rails.env.development? && Langtrainer.config.easy_sign_in_mode
    before_filter :easy_sign_in
  end

  def create
    email = params[:user][:email]
    if email.present?
      @user = User.find_or_create_by_email(email)
      if @user.valid?
        @user.reset_authentication_token!
        #UserMailer.delay.send_token(@user, I18n.locale)
        UserMailer.send_token(@user, I18n.locale).deliver!
        flash[:notice] = t('flash.token_authentication.email_sent', email: email)
      end
    end

    redirect_to login_path
  end

  private

  def easy_sign_in
    email = params[:user][:email]
    if email.present?
      @user = User.find_or_create_by_email(email)
      if @user.valid?
        return redirect_to root_path(auth_token: @user.authentication_token)
      end
    end

    redirect_to login_path
  end
end
