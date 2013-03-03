class Exercise
  extend ActiveModel::Naming

  attr_reader :id, :title

  def self.all
    exercises
  end

  def self.find(param)
    exercises[param.to_i]
  end

  def initialize(hsh = {})
    @id = hsh[:id]
    @title = hsh[:title]
  end

  def to_param
    id
  end

  def to_class_name
    'Exercise'
  end

  def persisted?
    false
  end

  def ==(obj)
    return obj == id if obj.is_a? Fixnum
    super
  end

  private

  def self.exercises
    @exercises ||= [
      Exercise.send(:new, id: 0, title: I18n.t('exercises.1.title')),
      Exercise.send(:new, id: 1, title: I18n.t('exercises.2.title'))
    ]
  end

  def self.first
    exercises.first
  end
end
