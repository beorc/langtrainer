class ActionMailer::Localized < ActionMailer::Base

  def default_url_options(options={})
    options_from_cfg = Rails.application.config.action_mailer.default_url_options
    options.merge(options_from_cfg).merge({ locale: @locale })
  end

  private

  def t(key)
    default_locale = I18n.locale
    I18n.locale = @locale
    result = I18n.t(key)
    I18n.locale = default_locale
    result
  end

  def localized_template(method_name)
    @template = "#{method_name}_#{@locale}"
  end

end
