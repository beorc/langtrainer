class ExercisesController < ApplicationController

  def show
    @exercise_id = params[:id].to_i
    @foreign_language = foreign_language
    sentences = Sentence.for_exercise(@exercise_id).
                         with_language(native_language)
    @sentences = sentences.sample sentences.count

    @hints = []
    (1..5).each do |i|
      hint = "#{@exercise_id}.#{@foreign_language.slug}_#{i}.jpeg"
      @hints << hint if Rails.application.assets.find_asset hint
    end
  end
end
