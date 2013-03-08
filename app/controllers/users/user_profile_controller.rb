class Users::UserProfileController < ApplicationController
  before_filter :authorized_only
  layout 'user_profile'

  private

  def authorized_only
    return if logged_in?
    flash[:notice] = t(:authorization_required)
    redirect_to login_path
  end

  def authorize_resource
    authorize! params[:action].to_sym, resource, message: t("flash.#{params[:controller]}.access_denied")
  end

  def gon_prepare_error_messages
    gon.unknown_error_message = t(:unknown_error_message)
  end
end
