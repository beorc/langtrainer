class EmailUniqueForUserValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if User.find_by_email(value).present?
      record.errors.add(attribute, :taken)
    end
  end
end

