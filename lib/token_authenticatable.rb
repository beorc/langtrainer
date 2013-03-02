module TokenAuthenticatable
  extend ActiveSupport::Concern

  def self.required_fields(klass)
    [:authentication_token]
  end

  # Generate new authentication token (a.k.a. "single access token").
  def reset_authentication_token
    self.authentication_token = self.class.authentication_token
  end

  # Generate new authentication token and save the record.
  def reset_authentication_token!
    reset_authentication_token
    save(:validate => false)
  end

  # Generate authentication token unless already exists.
  def ensure_authentication_token
    reset_authentication_token if authentication_token.blank?
  end

  # Generate authentication token unless already exists and save the record.
  def ensure_authentication_token!
    reset_authentication_token! if authentication_token.blank?
  end

  # Hook called after token authentication.
  def after_token_authentication
  end

  module ClassMethods
    def find_for_token_authentication(conditions)
      where(:authentication_token => conditions[Langtrainer.config.token_authentication_key])
    end

    # Generate a token checking if one does not already exist in the database.
    def authentication_token
      generate_token(:authentication_token)
    end

    # Generate a token by looping and ensuring does not already exist.
    def generate_token(column)
      loop do
        token = friendly_token
        break token if where({ column => token }).empty?
      end
    end

    def friendly_token
      SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
    end
  end
end
