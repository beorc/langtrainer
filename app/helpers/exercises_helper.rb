module ExercisesHelper
  def render_exercises_select
    options = exercises_list_options(include_all: false) do |exercise|
      language_exercise_path(@language.slug, id: exercise.id)
    end
    select_tag 'exercises', options
  end

  def accordion_body_class(exercise)
    return 'in' if exercise.id == @exercise.id
    ''
  end

  def atom_value(sentence)
    return 'true' if sentence.atom
    'false'
  end

  def hint_present?(exercise)
    Rails.root.join('app/views', "exercises/#{@language.slug}/#{native_language.slug}/_hint_#{exercise.slug}.html.slim")
  end

  def hint_partial(exercise)
    "exercises/#{@language.slug}/#{native_language.slug}/hint_#{exercise.slug}"
  end
end
