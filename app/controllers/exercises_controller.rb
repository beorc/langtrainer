class ExercisesController < ApplicationController

  def show
    @exercise = Exercise.find params[:id]
    @language = Language.find params[:language_id]
    @sentences = Sentence.for_exercise(@exercise).
                          with_language(@language).
                          with_language(native_language)

    @sentences = @exercise.shuffled? ? @sentences.shuffled : @sentences.ordered

    gon.increment_pass_counter_path = increment_pass_counter_path
  end

  def increment_pass_counter
    unless logged_in?
      render(status: 401, nothing: true) and return
    end
    current_user.increment_pass_counter!
    render status: 200, nothing: true
  end
end
