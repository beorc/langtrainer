module ExercisesHelper
  def render_exercises_select
    options = exercises_list_options(include_all: false) do |exercise|
      language_exercise_path(@language.slug, id: exercise.slug)
    end
    select_tag 'exercises', options
  end
end
