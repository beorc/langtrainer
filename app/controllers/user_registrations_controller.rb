class UserRegistrationsController < ApplicationController
  respond_to :html
  before_filter :require_login
  layout 'user_profile'

  def edit
    @user_decorator = UserRegistration.new(user: User.find(current_user.id))
    respond_with @user_decorator
  end

  def update
    @user_decorator = UserRegistration.new(user: User.find(current_user.id))
    @user_decorator.update_attributes(params[:user_registration])
    if @user_decorator.valid?
      #flash[:notice] = t('flash.user_registration.success')
      #flash[:notice] = t('flash.email_confirmation.email_sent', email: @user_decorator.email)
      redirect_to action: :edit
    else
      render action: :edit
    end
  end

  def confirm_email
    @user_decorator = UserRegistration.new(user: User.find(current_user.id))
    @user_decorator.email = current_user.email_confirmation.new_email
    if @user_decorator.valid?
      token = params.delete(:email_token)
      if token.present?
        if @user_decorator.email_confirmation.change_email(token)
          @user_decorator.email_confirmation.destroy
          flash[:notice] = t('flash.email_confirmation.success')
        else
          flash[:error] = t('flash.email_confirmation.fail')
        end
      end
      redirect_to action: :edit
    else
      render action: :edit
    end
  end

  def reset_email_confirmation
    @user_decorator = UserRegistration.new(user: User.find(current_user.id))
    @user_decorator.reset_email_confirmation!
    redirect_to :back
  end
end
