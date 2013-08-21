require 'spec_helper'

describe 'exercises/show' do
  it 'renders a hints' do
    #controller.prepend_view_path "app/views/admin"
    #Language.all.each do |language|
      #Exercise.all.each do |exercise|
        #assign :exercise, exercise
        #assign :language, language

        #render

        #assert_select ".accordion-body##{exercise.slug} .container"
      #end
    #end

    view.should_receive(:http_accept_language).and_return(HttpAcceptLanguage::Parser.new('ru-RU'))


    language = Language.english
    native_language = Language.russian
    assign :language, language
    exercise = Exercise.first

    assign :exercise, exercise
    assign :hints_path, "exercises/hints/#{exercise.id}/#{language.slug}/"
    sentences = Sentence.for_exercise(exercise).
                         with_language(language).
                         with_language(native_language)
    assign :sentences, sentences

    render

    assert_select ".accordion-body .container", count: EXERCISES_NUMBER
  end
end
