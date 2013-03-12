require 'spec_helper'

describe 'Corrections' do

  before :each do
    FactoryGirl.create :role

    @another_user = FactoryGirl.create :user
    @public_exercise = FactoryGirl.create :exercise
    @alien_exercise = FactoryGirl.create :exercise, owner: @another_user
    @own_exercise = FactoryGirl.create :exercise, owner: @user
  end

  context 'for member' do

    before :each do
      @user = sign_in_by_email
    end

    it 'allows to create own ones', js: true do
      visit users_sentences_path
      page.has_selector?('body.user-profile')

      en_input = find('.sentence:first .translation[data-lang=en] textarea')
      en_input.set 'I love you'
      en_input[:class].include?('changed').should == true
      find('a.save-sentence', visible: true).click
      page.has_selector?(".changes-applied")
      changed_input = find('.changes-applied')
      changed_input[:id].should == en_input[:id]
    end

    it 'allows to destroy own ones', js: true do
      sentence = @public_exercise.sentences.first
      correction = FactoryGirl.create :correction, sentence: sentence, exercise: @public_exercise, owner: @user

      visit users_sentences_path(sentence: sentence)

      en_input = find('.sentence:first .translation[data-lang=en] textarea')
      en_input.text.should == correction.en

      find('.destroy-sentence').click

      check_alert(I18n.t(:delete_confirm))

      visit users_sentences_path(sentence: sentence)

      Correction.where(id: correction.id).empty?.should == true

      en_input = find('.sentence:first .translation[data-lang=en] textarea')
      en_input.text.should == sentence.en
    end
  end

  context 'for admin' do
    before :each do
      @admin = sign_in_as_admin
    end

    it 'are not create', js: true do
      user = FactoryGirl.create :user
      sentence = @public_exercise.sentences.first
      correction = FactoryGirl.create :correction, sentence: sentence, exercise: @public_exercise, owner: user

      visit users_sentences_path(sentence: sentence)

      en_input = find('.sentence:first .translation[data-lang=en] textarea')
      en_input.text.should == sentence.en

      find('.destroy-sentence').click

      check_alert(I18n.t(:delete_confirm))

      visit root_path

      Sentence.where(id: sentence.id).empty?.should == true
      Correction.where(id: correction.id).empty?.should == true
    end
  end
end

