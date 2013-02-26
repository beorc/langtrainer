class Sentence < ActiveRecord::Base
  belongs_to :language
  attr_accessible :russian, :english, :exercise_id

  validates :russian, :english, uniqueness: true

  scope :for_exercise, ->(exercise_id) { where(exercise_id: exercise_id) }
end
