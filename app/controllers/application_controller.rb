class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :native_language

  before_filter :handle_sign_in
  before_filter :store_current_url
  before_filter :build_meta_tags, only: [:index, :show]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def native_language
    session[:language_id] ||= logged_in? ? current_user.language.id : Language.russian.id
    Language.find(session[:language_id])
  end

  private

  def handle_sign_in
    if params[Langtrainer.config.token_authentication_key].present?
      redirect_path = session[:current_url] || root_path

      if logged_in?
        current_user.reset_authentication_token!
        redirect_to redirect_path
      else
        user = User.find_for_token_authentication(params).first
        if user
          user.after_token_authentication
          auto_login(user)
          flash[:notice] = t('flash.token_authentication.success')
          redirect_to redirect_path
        else
          flash[:error] = t('flash.token_authentication.fail')
          redirect_to login_path
        end
      end
    end
  end

  def store_current_url
    return if request.format.nil?
    return unless request.format.html?
    return if logged_in?

    excluded_controllers = ['user_registrations',
                            'user_sessions',
                            'user_workspace',
                            'token_authentications']

    current_controller = params[:controller]

    if !excluded_controllers.include?(current_controller) &&
       !current_controller.include?('users')
      session[:current_url] = request.url
    end
  end

  def build_meta_tags
    current_controller = params[:controller]
    @@tags ||= {}
    tags = @@tags[current_controller] ||= t("meta_tags.#{current_controller}", default: '').clone
    tags.blank? && return

    set_meta_tags tags
  end
end
