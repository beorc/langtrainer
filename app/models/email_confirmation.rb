class EmailConfirmation < ActiveRecord::Base
  attr_accessible :new_email, :user

  belongs_to :user

  validates :new_email, presence: true,
                        email_unique_for_user: true,
                        format: { with: Langtrainer.email_regexp }
  validates :user, presence: true

  def reset_token!
    self.token = SecureRandom.hex(8)
  end

  def change_email(received_token)
    if received_token == token
      reset_token!
      user.email = new_email
      return user.save
    end
    false
  end

  def save(*)
    # не пытаемся сохранить в таблицу, если емайл не изменился
    if email_changed?
      send_email
      super
    else
      true
    end
  end

  def email_changed?
    new_email != user.email
  end

  private

  def send_email
    reset_token!
    #UserMailer.delay.send_email_confirmation(self, I18n.locale)
    UserMailer.send_email_confirmation(self, I18n.locale).deliver!
  end
end
