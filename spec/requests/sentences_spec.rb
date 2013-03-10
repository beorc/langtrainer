require 'spec_helper'

describe 'Sentences' do

  before :each do
    FactoryGirl.create :role

    @another_user = FactoryGirl.create :user
    @public_exercise = FactoryGirl.create :exercise
    @alien_exercise = FactoryGirl.create :exercise, owner: @another_user
    @own_exercise = FactoryGirl.create :exercise, owner: @user
    @user = sign_in_by_email
    visit users_sentences_path
    page.has_selector?('body.user-profile')
  end

  context 'for member' do
    it 'allows to correct public ones', js: true do
      en_input = find('.sentence:first .translation[data-lang=en] textarea')
      en_input.set 'I love you'
      en_input[:class].include?('changed').should == true
      find('a.save-sentence', visible: true).click
      page.has_selector?(".changes-applied")
      changed_input = find('.changes-applied')
      changed_input[:id].should == en_input[:id]
    end

    it 'allows to create own ones', js: true do
      find('a.new-sentence').click

      page.has_selector?('body.sentences.new')
      en_text = 'I love you'
      exercise_title = Exercise.first.title
      fill_in('sentence_en', with: en_text)
      select exercise_title, from: 'sentence_exercise_id'
      find('.form-actions .btn-primary').click

      page.has_selector?('body.sentences.show')
      find('#flash_notice').text.should eq I18n.t('flash.sentence.create.success')
      page.has_text?(en_text).should be true
      page.has_text?(exercise_title).should be true
    end

    it 'allows to change own ones', js: true do
      sentence = FactoryGirl.create :sentence, exercise: @public_exercise, owner: @user, en: 'I love them'
      visit edit_users_sentence_path(sentence)

      page.has_selector?('body.sentences.edit')
      en_text = 'I love them all'
      exercise_title = Exercise.last.title
      fill_in('sentence_en', with: en_text)
      select exercise_title, from: 'sentence_exercise_id'
      find('.form-actions .btn-primary').click

      page.has_selector?('body.sentences.show')
      find('#flash_notice').text.should eq I18n.t('flash.sentence.update.success')
      page.has_text?(en_text).should be true
      page.has_text?(exercise_title).should be true
    end

    it 'allows to destroy own ones', js: true do
      sentence = FactoryGirl.create :sentence, exercise: @public_exercise, owner: @user, en: 'I love them'
      visit users_sentence_path(sentence)

      page.has_selector?('body.sentences.show')

      find('.form-actions .btn-destroy').click

      check_alert(I18n.t(:delete_confirm))

      page.has_selector?('body.sentences.index')
      find('body.sentences.index')
    end
  end
end

