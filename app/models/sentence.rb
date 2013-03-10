class Sentence < ActiveRecord::Base
  attr_accessible :ru, :en, :exercise, :exercise_id, :atom

  after_create :assign_position, unless: 'position?'

  belongs_to :exercise
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :corrections, class_name: 'Correction', foreign_key: 'sentence_id'

  validates :exercise, existence: { both: false }
  validates :sentence_id, uniqueness: { scope: :user_id }, allow_nil: true

  scope :not_corrections, -> { where(type: nil) }
  scope :for_exercise, ->(exercise) { where(exercise_id: Exercise.find(exercise).id)}
  scope :order_by_position, -> { order('position ASC') }

  def self.for_user(user)
    where('user_id IS NULL OR user_id = ?', user.id) - joins(:corrections).where('corrections_sentences.user_id = ?', user.id)
  end

  private

  def assign_position
    self.position = id
    save
  end
end
