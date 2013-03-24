require File.join(Rails.root, 'lib/validators/email_unique_for_user.rb')

class UserRegistration
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include Virtus

  attribute :email, String

  validates :email, email_unique_for_user: true,
                    format: { with: Langtrainer.email_regexp }

  attr_reader :email_confirmation

  def initialize(hsh)
    @user = hsh.delete(:user)
    @email_confirmation = @user.email_confirmation || @user.build_email_confirmation
    super hsh.merge(email: @user.email)
  end


  # Forms are never themselves persisted
  def persisted?
    false
  end

  def update_attributes(attributes)
    self.attributes = attributes
    @email_confirmation.new_email = email
    @email_confirmation.save
    attributes.delete :email
    @user.update_attributes attributes
    save
  end

  def save
    if valid? && @user.valid?
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
end

