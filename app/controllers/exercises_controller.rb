class ExercisesController < ApplicationController

  def show
    @exercise = Exercise.find params[:id]
    sentences = Sentence.for_exercise(@exercise)
    @sentences = sentences.training_order
    @language = Language.find params[:language]

    @hint = "exercises/#{native_language.slug}/hint_#{@exercise.slug}" if @exercise.owner.nil?
  end
end
