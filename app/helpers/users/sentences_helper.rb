module Users::SentencesHelper
  def url_options_for_sentence(sentence)
    if sentence.type == 'Correction'
      return { url: users_correction_path(sentence), method: 'put'}
    elsif sentence.owner.try(:id) == current_user.id || current_user.admin?
      return { url: users_sentence_path(sentence), method: 'put'}
    end
    { url: users_corrections_path, method: 'post' }
  end

  def render_exercises_select
    options = exercises_list_options do |exercise|
      url_params = {}
      url_params.merge!({ exercise: exercise }) if exercise.present?
      url_params.merge!( @search_filter ) if @search_filter.present?
      users_sentences_path(url_params)
    end
    select_tag 'exercises', options
  end
end
