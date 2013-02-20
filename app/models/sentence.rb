class Sentence < ActiveRecord::Base
  belongs_to :language
  attr_accessible :content, :template, :language_id

  validates :content, :template, :language_id, presence: true

  scope :for_exercise, ->(exercise) { where('template LIKE "?:%"', exercise) }
  scope :with_language, ->(language) { where(language_id: language) }

  def self.random_one
    if (c = count) != 0
      find(:first, offset: rand(c))
    end
  end
end
