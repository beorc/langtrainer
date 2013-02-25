class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :native_language
  helper_method :foreign_language

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def native_language
    return current_user.native_language if logged_in?
    session[:native_language] ||= Language.russian
  end

  def foreign_language
    return current_user.foreign_language if logged_in?
    session[:foreign_language] ||= Language.english
  end
end
