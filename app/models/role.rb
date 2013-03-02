class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  attr_accessible :name

  scopify

  DEFAULT = :member

  def self.default
    Role.first(conditions: {name: DEFAULT})
  end
end
