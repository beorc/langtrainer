class User < ActiveRecord::Base
  include TokenAuthenticatable

  has_many :providers, :class_name => 'UserProvider', :dependent => :destroy
  has_many :sentences
  has_many :corrections
  has_many :exercises
  has_many :feedbacks
  has_one :email_confirmation, validate: true
  has_many :topics, dependent: :destroy
  has_many :posts, dependent: :destroy
  accepts_nested_attributes_for :providers

  authenticates_with_sorcery!
  rolify

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin

  attr_accessible :email, :providers_attributes, :nickname

  validates :nickname, uniqueness: true, if: :nickname?
  validates :email, uniqueness: true,
                    format: { with: Langtrainer.email_regexp },
                    if: 'email.present?'
  validates :email, presence: true, if: :email_required?

  validates :username, presence: true,
                       uniqueness: true,
                       if: :have_bound_auth?

  after_create :assign_default_languages
  after_create :assign_default_role
  before_save :ensure_authentication_token

  scope :admins, -> { with_role(:admin) }

  def after_token_authentication
    reset_authentication_token!
  end

  def after_oauth_sign_in!
    assign_default_languages
    assign_default_role
  end

  def title
    nickname || email || username
  end

  def friendly_title
    nickname || username || email.split('@').first
  end

  def language
    assign_default_languages if language_id.nil?
    Language.find(language_id)
  end

  def assign_default_role
    return unless roles.empty?
    roles << Role.default
    save(:validate => false)
  end

  def admin?
    has_role? :admin
  end

  def summary_passes
    en_counter + ru_counter
  end

  def increment_pass_counter!
    case language.slug
    when :ru
      self.en_counter += 1
    when :en
      self.ru_counter += 1
    end

    save
  end

  def self.top(number)
    order('(en_counter + ru_counter) DESC').where('en_counter + ru_counter > 0').limit(number)
  end

  private

  def assign_default_languages
    self.language_id = Language.russian
    save(:validate => false)
  end

  def email_required?
    providers.empty?
  end

  def have_bound_auth?
    providers.any?
  end
end
