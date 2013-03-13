class UserMailer < ActionMailer::Localized

  def send_token(url_params, email, locale)
    @locale = locale
    @url = root_url(url_params)
    mail(to: email, subject: t('mailer.token_authentication.subject'),
                          template_name: localized_template(__method__))
  end

  def send_email_confirmation(token, email, locale)
    @locale = locale
    @url = confirm_email_url(email_token: token)
    mail(to: email, subject: t('mailer.email_confirmation.subject'),
                          template_name: localized_template(__method__))
  end
end
