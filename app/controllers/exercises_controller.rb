class ExercisesController < ApplicationController

  def show
    @exercise = Exercise.find params[:id]
    sentences = Sentence.for_exercise(@exercise)
    @sentences = sentences.training_order
    @language = Language.find params[:language_id]

    hint = "exercises/#{@language.slug}/hint_#{@exercise.slug}"
    hint_path = Rails.root.join('app', 'views', "#{hint_path}.#{I18n.locale}.html.slim")
    @hint = hint_path if File.exists?(hint_path)
  end
end
