class FeedbackMailer < ActionMailer::Base
  def send_notification_email(emails, options)
    options[:url_options][:host] = Langtrainer.localized_url
    @options = options
    @options[:url] = admin_feedback_url(options[:url_options])

    subject = I18n.t('mailer.feedback.subject')
    mail(to: emails, subject: subject)
  end
end
