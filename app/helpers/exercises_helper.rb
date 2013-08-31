module ExercisesHelper
  def render_exercises_select
    options = exercises_list_options(include_all: false) do |exercise|
      language_exercise_path(@language.slug, id: exercise.slug)
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

  def exercise_path(exercise)
    File.join('exercises/hints', exercise.slug.to_s)
  end

  def exercise_partial(exercise, partial)
    File.join(exercise_path(exercise), partial.to_s)
  end

  def lang_hint_partial(exercise, partial)
    File.join(hints_path(exercise), partial.to_s)
  end

  def hints_path(exercise)
    exercise_partial(exercise, @language.slug)
  end

  def hint_present?(exercise)
    File.exists? Rails.root.join('app/views', hints_path(exercise), "_#{native_language.slug}.html.slim")
  end

  def hint_partial(exercise)
    lang_hint_partial(exercise, native_language.slug)
  end

  def t(key, options = {})
    return super if I18n.locale == native_language.slug and !options[:foreign]
    return super unless options[:hint]

    current_locale = I18n.locale

    if options[:foreign]
      I18n.locale = @language.slug
    else
      I18n.locale = native_language.slug
    end

    result = I18n.t(key, options)
    I18n.locale = current_locale
    result
  end
end
