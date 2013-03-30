class Sentence < ActiveRecord::Base
  attr_accessible :ru, :en, :exercise_id, :atom

  after_create :assign_position, unless: 'position?'

  belongs_to :exercise
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :corrections, class_name: 'Correction', foreign_key: 'sentence_id', dependent: :destroy

  validates :exercise_id, existence: { both: false }
  validates :sentence_id, uniqueness: { scope: :user_id }, allow_nil: true

  scope :not_corrections, -> { where(type: nil) }
  scope :for_exercise, ->(exercise) { where(exercise_id: exercise.id)}
  scope :order_by_position, -> { order('position ASC') }
  scope :atoms, -> { where(atom: true) }
  scope :compound, -> { where('atom IS NULL OR atom = false') }
  scope :with_language, ->(language) { where('? IS NOT NULL', language.slug) }
  def self.for_user(user)
    where('user_id IS NULL OR user_id = ?', user.id) - joins(:corrections).where('corrections_sentences.user_id = ?', user.id)
  end

  def self.training_order
    atoms + compound.sample(count)
  end

  def correction_by(user)
    corrections.where( user_id: user.id ).first
  end

  def correction?
    type == 'Correction'
  end

  private

  def assign_position
    self.position = id
    save
  end
end
