class FeedbackMailer < ActionMailer::Localized
  def send_notification_email(emails, locale, options)
    @locale = locale
    @options = options
    @options[:url] = admin_feedback_url(options[:url_options])

    subject = I18n.t('mailers.feedback.subject')
    mail(to: emails, subject: subject,
                    template_name: localized_template(__method__))
  end
end
