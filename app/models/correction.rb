class Correction < Sentence
  belongs_to :sentence

  validates :sentence, :owner, existence: { both: false }

  delegate :exercise_id, to: :sentence
end
