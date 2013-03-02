class UserRegistrationsController < ApplicationController
  before_filter :require_login
  helper_method :resource
  #layout 'user_profile'

  def update
    resource.update_attributes(params[:user_registration])
    if resource.save
      flash[:success] = t('flash.user_registration.success')
      flash[:notice] = t('flash.email_confirmation.email_sent', email: resource.email)
      redirect_to action: :edit
    else
      render action: :edit
    end
  end

  def confirm_email
    if resource.valid?
      token = params.delete(:email_token)
      if token.present?
        if resource.email_confirmation.change_email(token)
          resource.email_confirmation.destroy
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

  private

  def resource
    @user_registration ||= UserRegistration.new(user: current_user)
  end
end
