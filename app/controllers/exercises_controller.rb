class ExercisesController < ApplicationController

  def show
    @exercise = Exercise.find params[:id]
    @language = Language.find params[:language_id]
    @sentences = Sentence.for_exercise(@exercise).
                          with_language(@language).
                          with_language(native_language).
                          training_order

    gon.increment_pass_counter_path = increment_pass_counter_path
  end

  def increment_pass_counter
    current_user.try :increment_pass_counter!
    render status: 200, nothing: true
  end
end
