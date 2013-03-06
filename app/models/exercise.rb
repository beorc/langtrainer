class Exercise < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  attr_accessible :title, :slug

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :sentences

  validates :title, presence: true, uniqueness: { scope: :user_id }

  def should_generate_new_friendly_id?
    new_record? && !slug
  end
end
