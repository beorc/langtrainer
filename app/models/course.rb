class Course < ActiveRecord::Base
  attr_accessible :description, :slug, :title

  has_many :exercises

  validates :title, uniqueness: { scope: :user_id }
  validates :slug, uniqueness: { scope: :user_id }

  def title
    return super if slug.blank?
    I18n.t(['titles', self.class.model_name.downcase, slug].join('.'), default: super)
  end
end
