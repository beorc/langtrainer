require File.join(Rails.root, 'lib/validators/email_unique_for_user.rb')

class UserRegistration
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include Virtus

  attribute :nickname, String
  attribute :email, String

  validates :email, email_unique_for_user: true,
                    format: { with: Langtrainer.email_regexp },
                    if: :email_changed?

  attr_reader :email_confirmation
  attr_reader :user

  def initialize(hsh)
    @user = hsh.delete(:user)
    @email_confirmation = @user.email_confirmation || @user.build_email_confirmation
    super hsh.merge(email: @user.email, nickname: @user.nickname)
  end


  # Forms are never themselves persisted
  def persisted?
    false
  end

  def update_attributes(attributes)
    attributes.delete('nickname') if attributes['nickname'].blank?
    attributes.delete('email') if attributes['email'].blank?
    self.attributes = attributes
    @email_confirmation.new_email = email
    @email_confirmation.save
    @user.update_attributes attributes.except(:email)
    save
  end

  def valid?
    result = super && @user.valid?
    if @user.errors[:nickname].present?
      errors.add :nickname, @user.errors[:nickname].join(', ')
    end
    result
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def reset_email_confirmation!
    @email_confirmation.destroy
  end

  private

  def persist!
    @user.save
  end

  def email_changed?
    !email.nil? and email != @user.email
  end
end

