class Exercise < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  attr_accessible :title, :slug, :shuffled

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :sentences
  has_many :corrections

  #validates :title, presence: true, uniqueness: { scope: :user_id }

  scope :for_user, ->(user) { user.present? ? where('exercises.user_id IS NULL OR exercises.user_id = ?', user.id) : scoped }
  scope :not_empty, -> { joins(:sentences).where('sentences.id IS NOT NULL').group('exercises.id') }
  scope :public, -> { where(user_id: nil) }

  def should_generate_new_friendly_id?
    new_record? && !slug
  end

  def title
    I18n.t(['titles', self.class.model_name.downcase, slug].join('.'))
  end
end
