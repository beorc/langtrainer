class ExercisesController < ApplicationController

  def show
    @exercise_id = params[:id].to_i
    sentences = Sentence.for_exercise(@exercise_id)
    @sentences = sentences.sample sentences.count
    @language = Language.find params[:language]

    @hint = "exercises/#{native_language.slug}/hint_#{@exercise_id}"
  end
end
