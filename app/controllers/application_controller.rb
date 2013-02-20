class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  private

  def current_user
    super || User.default
  end

  def logged_in?
    return false if current_user.id == User.default.id
    super
  end
end
