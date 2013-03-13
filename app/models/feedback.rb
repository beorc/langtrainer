class Feedback < ActiveRecord::Base
  attr_accessible :email, :message

  belongs_to :user

  validates :email, format: { with: Langtrainer.email_regexp }, if: 'email?'
  validates :message, presence: true

  after_save :send_notifications

  private

  def send_notifications
    emails = ::User.admins.map(&:email).compact

    FeedbackMailer.delay.send_notification_email(emails, I18n.locale, url_options: { id: id },
                                                                      email: email,
                                                                      message: message)
  end
end
