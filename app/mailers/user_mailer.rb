class UserMailer < ActionMailer::Localized

  def send_token(user, locale)
    @locale = locale
    @url = root_url(Langtrainer.config.token_authentication_key => user.authentication_token)
    mail(to: user.email, subject: t('mailer.token_authentication.subject'),
                          template_name: localized_template(__method__))
  end

  def send_email_confirmation(email_confirmation, locale)
    @locale = locale
    @url = confirm_email_url(email_token: email_confirmation.token)
    mail(to: email_confirmation.new_email, subject: t('mailer.email_confirmation.subject'),
                          template_name: localized_template(__method__))
  end
end
