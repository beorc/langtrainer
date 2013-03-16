class ExercisesController < ApplicationController

  def show
    @exercise = Exercise.find params[:id]
    sentences = Sentence.for_exercise(@exercise)
    @sentences = sentences.training_order
    @language = Language.find params[:language_id]
  end
end
