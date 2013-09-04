class FeedbackMailer < ActionMailer::Base
  def send_notification_email(emails, options)
    @options = options
    @options[:url] = admin_feedback_url

    subject = I18n.t('mailer.feedback.subject')
    mail(to: emails, subject: subject)
  end
end
