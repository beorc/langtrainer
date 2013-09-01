require 'spec_helper'

describe 'exercises/show' do
  it 'renders a hints' do
    Language.all.each do |native_language|
      Language.except(native_language).each do |language|
        view.stub(:http_accept_language).and_return(HttpAcceptLanguage::Parser.new(native_language.slug.to_s))
        view.stub(:native_language).and_return native_language
        assign :language, language
        exercise = Exercise.first

        assign :exercise, exercise
        assign :hints_path, "exercises/hints/#{exercise.id}/#{language.slug}/"
        sentences = Sentence.for_exercise(exercise).
                             with_language(language).
                             with_language(native_language)
        assign :sentences, sentences

        render

        assert_select ".accordion-body .container", minimum: 2
      end
    end
  end
end
