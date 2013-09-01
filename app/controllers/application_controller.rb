class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery

  helper_method :native_language, :has_native_language?

  before_filter :handle_sign_in
  before_filter :store_current_url
  before_filter :build_meta_tags
  before_filter :prepare_gon
  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def has_native_language?
    session[:selected_language_id] ||= current_user.language.id if logged_in? and current_user.has_assigned_language?
    session[:selected_language_id].present?
  end

  def native_language
    Language.find(session[:language_id] || build_native_language)
  end

  private

  def build_native_language
    session[:language_id] = session[:selected_language_id]
    session[:language_id] ||= logged_in? ? current_user.language.id : Language.find(guess_locale).id
    change_locale
    session[:language_id]
  end

  def change_native_language(language)
    session[:selected_language_id] = session[:language_id] = language.id
    if logged_in?
      current_user.update_attribute 'language_id', language.id
    end
    change_locale
    Language.find(session[:language_id])
  end

  def change_locale
    if native_language.russian?
      I18n.locale = :ru
    else
      I18n.locale = :en
    end
  end

  def guess_locale
    available = %w{ru en}
    locale = http_accept_language.compatible_language_from(available)
    return locale.to_sym if locale.present?

    :en
  end

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
    logger.info "==Controller== #{current_controller}"
    tags = t("meta_tags.#{current_controller}", default: { title: t(:app_name) } ).clone
    tags.blank? && return

    set_meta_tags tags
  end

  def prepare_gon
    #gon.ym = nil
    if Rails.env.production?
      id = ENV['YANDEX_METRIKA_ID']
      gon.ym = id if id
      gon.locale = I18n.locale.to_s
      gon.shares_title = t(:shares_title)
    end
  end

  def set_locale
    if params[:locale].present? && params[:locale] != native_language.slug
      return change_native_language(Language.find(params[:locale]))
    end

    change_locale if I18n.locale != native_language.slug
  end
end
