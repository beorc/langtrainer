class UserMailer < ActionMailer::Localized

  def send_token(url_params, email, locale)
    @locale = locale
    url_params[:host] = Langtrainer.localized_url
    @url = root_url(url_params)
    mail(to: email, subject: t('mailer.token_authentication.subject'),
                          template_name: localized_template(__method__))
  end

  def send_email_confirmation(token, email, locale)
    @locale = locale
    url_params = {host: Langtrainer.localized_url, email_token: token}
    @url = confirm_email_url(url_params)
    mail(to: email, subject: t('mailer.email_confirmation.subject'),
                          template_name: localized_template(__method__))
  end
end
