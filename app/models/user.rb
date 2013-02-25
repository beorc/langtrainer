class User < ActiveRecord::Base
  has_many :providers, :class_name => 'UserProvider', :dependent => :destroy
  accepts_nested_attributes_for :providers

  authenticates_with_sorcery!
  rolify
  # attr_accessible :title, :body

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin

  attr_accessible :email, :password, :password_confirmation, :providers_attributes

  validates_length_of :password, :minimum => 3, :message => "password must be at least 3 characters long", :if => :password
  validates_confirmation_of :password, :message => "should match confirmation", :if => :password

  after_create :assign_default_languages

  def native_language
    Language.find native_language_id
  end

  def foreign_language
    Language.find foreign_language_id
  end

  private

  def assign_default_languages
    self.foreign_language_id = Language.english.id
    self.native_language_id = Language.russian.id
    save!
  end
end
