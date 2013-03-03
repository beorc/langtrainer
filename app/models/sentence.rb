class Sentence < ActiveRecord::Base
  attr_accessible :russian, :english, :exercise_id

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :corrections, class_name: 'Correction', foreign_key: 'sentence_id'

  validates :russian, :english, uniqueness: true
  validates :exercise_id, presence: true

  scope :for_exercise, ->(exercise_id) { where(exercise_id: exercise_id) }
end
