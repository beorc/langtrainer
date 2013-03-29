class ExercisesController < ApplicationController

  def show
    @exercise = Exercise.find params[:id]
    @sentences = Sentence.for_exercise(@exercise).training_order
    @language = Language.find params[:language_id]

    gon.increment_pass_counter_path = increment_pass_counter_path
  end

  def increment_pass_counter
    current_user.increment_pass_counter!
    render status: 200, nothing: true
  end
end
