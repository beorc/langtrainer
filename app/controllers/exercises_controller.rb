class ExercisesController < ApplicationController

  def show
    @exercise = Exercise.find params[:id]
    sentences = Sentence.for_exercise(@exercise)
    @sentences = sentences.training_order
    @language = Language.find params[:language_id]

    hint = "exercises/#{@language.slug}/hint_#{@exercise.slug}"
    hint_path = Rails.root.join('app', 'views', 'exercises', @language.slug.to_s, "_hint_#{@exercise.slug}.#{I18n.locale}.html.slim").to_s
    @hint = hint if File.exists?(hint_path)
  end
end
