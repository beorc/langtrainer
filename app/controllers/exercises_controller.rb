class ExercisesController < ApplicationController

  def show
    @exercise_id = params[:id].to_i
    sentences = Sentence.for_exercise(@exercise_id).
                         with_language(native_language)
    @sentences = sentences.sample sentences.count

    @hint = "exercises/#{native_language.slug}/hint_#{@exercise_id}"
  end
end
