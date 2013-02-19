class ExercisesController < ApplicationController
  def show
    @sentence = Sentence.by_exercise(params[:id].to_i).random_one
  end
end
