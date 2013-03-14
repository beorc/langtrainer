require 'spec_helper'

describe 'Sentences' do

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

      page.has_selector?('body.sentences.index')
      find('#flash_notice').text.should eq I18n.t('flash.sentence.update.success')
      page.has_text?(en_text).should be true
      page.has_text?(exercise_title).should be true
    end

    it 'allows to destroy own ones', js: true do
      sentence = FactoryGirl.create :sentence, exercise: @public_exercise, owner: @user, en: 'I love them'
      visit users_sentences_path(sentence: sentence)

      page.has_selector?('body.sentences.index')

      find('.destroy-sentence').click

      check_alert(I18n.t(:delete_confirm))

      page.has_selector?('body.sentences.index')
      find('body.sentences.index')

      Sentence.where(id: sentence.id).empty?.should == true
    end
  end

  context 'for admin' do
    before :each do
      @admin = sign_in_as_admin
    end

    it 'allows to create public ones', js: true do
      visit users_sentences_path
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

      Sentence.last.user_id.should be nil
      Sentence.last.sentence_id.should be nil
      Sentence.last.en.should == en_text
    end

    it 'allows to change users ones', js: true do
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

    it 'allows to change public ones', js: true do
      sentence = @public_exercise.sentences.first
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

    it 'allows to destroy public ones', js: true do
      sentence = FactoryGirl.create :sentence, exercise: @public_exercise, owner: @user, en: 'I love them'
      visit users_sentences_path(sentence: sentence)

      page.has_selector?('body.sentences.index')

      find('.destroy-sentence').click

      check_alert(I18n.t(:delete_confirm))

      page.has_selector?('body.sentences.index')
      find('body.sentences.index')

      Sentence.where(id: sentence.id).empty?.should == true
    end
  end
end

