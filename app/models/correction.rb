class Correction < Sentence
  belongs_to :sentence

  validates :sentence, :owner, existence: { both: false }

  delegate :exercise_id, to: :sentence

  def init_from(sentence)
    self.sentence = sentence
    self.exercise = sentence.exercise
    self.position = sentence.position
    Language.all.each do |lang|
      attr = lang.slug
      unless send(attr).present?
        send("#{attr}=", sentence.send(attr))
      end
    end
    self
  end
end
