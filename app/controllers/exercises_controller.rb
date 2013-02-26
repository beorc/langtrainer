class ExercisesController < ApplicationController

  def show
    @exercise_id = params[:id].to_i
    sentences = Sentence.for_exercise(@exercise_id)
    @sentences = sentences.sample sentences.count

    @hint = "exercises/#{native_language}/hint_#{@exercise_id}"
  end
end
