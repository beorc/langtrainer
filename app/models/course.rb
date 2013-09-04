class Course < ActiveRecord::Base
  attr_accessible :description, :slug, :title

  has_many :exercises

  validates :title, uniqueness: { scope: :user_id }
  validates :slug, uniqueness: { scope: :user_id }

  scope :for_user, ->(user) { user.present? ? where('courses.user_id IS NULL OR courses.user_id = ?', user.id) : scoped }
  scope :not_empty, -> { joins(:exercises).where('exercises.id IS NOT NULL').group('courses.id') }
  scope :public, -> { where(user_id: nil) }

  def title
    return super if slug.blank?
    I18n.t(['titles', self.class.model_name.downcase, slug].join('.'), default: super)
  end
end
