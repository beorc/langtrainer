require 'spec_helper'

describe ExercisesController do

  it 'renders show page' do
    Language.all.each do |language|
      Exercise.all.each do |exercise|
        get :show, id: exercise.id, language_id: language.slug
        response.should be_success
      end
    end
  end
end
