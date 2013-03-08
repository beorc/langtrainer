class Exercise < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  attr_accessible :title, :slug

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :sentences

  validates :title, presence: true, uniqueness: { scope: :user_id }

  scope :for_user, ->(user) { where('user_id IS NULL OR user_id = ?', user.id) }

  def should_generate_new_friendly_id?
    new_record? && !slug
  end
end
