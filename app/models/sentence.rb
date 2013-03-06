class Sentence < ActiveRecord::Base
  attr_accessible :ru, :en, :exercise

  belongs_to :exercise
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :corrections, class_name: 'Correction', foreign_key: 'sentence_id'

  validates :ru, :en, uniqueness: true
  validates :exercise, existence: { both: false }

  scope :for_exercise, ->(exercise) { where(exercise_id: exercise.id) }
end
