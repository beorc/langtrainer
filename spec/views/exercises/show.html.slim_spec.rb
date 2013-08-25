require 'spec_helper'

describe 'exercises/show' do
  it 'renders a hints' do
    language = Language.english
    native_language = Language.russian
    view.should_receive(:http_accept_language).and_return(HttpAcceptLanguage::Parser.new(native_language.slug.to_s))
    assign :language, language
    exercise = Exercise.first

    assign :exercise, exercise
    assign :hints_path, "exercises/hints/#{exercise.id}/#{language.slug}/"
    sentences = Sentence.for_exercise(exercise).
                         with_language(language).
                         with_language(native_language)
    assign :sentences, sentences

    render

    assert_select ".accordion-body .container", count: 1
  end
end
