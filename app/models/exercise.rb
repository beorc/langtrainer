class Exercise < ActiveRecord::Base
  attr_accessible :title, :slug, :shuffled, :course_id

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  belongs_to :course
  has_many :sentences
  has_many :corrections

  validates :title, uniqueness: { scope: [:user_id, :course_id] }, if: :title?
  validates :slug, uniqueness: { scope: [:user_id, :course_id] }, if: :slug?
  validates :course_id, presence: true

  scope :for_user, ->(user) { user.present? ? where('exercises.user_id IS NULL OR exercises.user_id = ?', user.id) : scoped }
  scope :not_empty, -> { joins(:sentences).where('sentences.id IS NOT NULL').group('exercises.id') }
  scope :public, -> { where(user_id: nil) }
  scope :order_by_course, -> { order('course_id') }

  def should_generate_new_friendly_id?
    new_record? && !slug
  end

  def title
    return super if slug.blank?
    I18n.t(['titles', self.class.model_name.downcase, course.slug, slug].join('.'), default: super)
  end

  def to_param
    return slug if slug.present?
    id
  end
end
