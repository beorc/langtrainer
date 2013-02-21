class ExercisesController < ApplicationController

  def show
    exercise_id = params[:id].to_i
    @foreign_language = current_user.foreign_language
    sentences = Sentence.for_exercise(exercise_id).
                         with_language(current_user.native_language)
    @sentences = sentences.sample sentences.count
  end
end
