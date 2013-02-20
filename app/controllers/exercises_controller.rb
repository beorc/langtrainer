class ExercisesController < ApplicationController

  def show
    exercise_id = params[:id].to_i
    @sentence = Sentence.for_exercise(exercise_id).
                         with_language(current_user.foreign_language.id).
                         random_one
    gon.template = @sentence.template
  end
end
