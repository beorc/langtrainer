class Sentence < ActiveRecord::Base
  belongs_to :language
  attr_accessible :content, :template, :language_id

  validates :content, :template, :language_id, presence: true

  scope :for_exercise, ->(exercise) { where('template LIKE "?:%"', exercise) }
  scope :with_language, ->(language) { where(language_id: language.id) }
  scope :with_template, ->(template) { where(template: template) }

  def translation_to(language)
    Sentence.with_language(language).with_template(template).first
  end
end
