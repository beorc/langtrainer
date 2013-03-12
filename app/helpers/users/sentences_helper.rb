module Users::SentencesHelper
  def url_options_for_sentence(sentence)
    if sentence.type == 'Correction'
      return { url: users_correction_path(sentence), method: 'put'}
    elsif sentence.owner.try(:id) == current_user.id || current_user.admin?
      return { url: users_sentence_path(sentence), method: 'put'}
    end
    { url: users_corrections_path, method: 'post' }
  end

  def exercises_list_options
    options = content_tag( :option, t(:all), value: 0, url: users_sentences_path(@search_filter))
    Exercise.for_user(current_user).each do |exercise|
      url_params = { exercise: exercise }
      url_params.merge!( @search_filter ) if @search_filter.present?
      parameters = { value: exercise.id, url: users_sentences_path(url_params) }
      if @exercise.present? && exercise.id == @exercise.id
        parameters.merge!({ selected: 'selected' })
      end

      options << content_tag(:option, parameters) do
        exercise.title
      end
    end
    options.html_safe
  end
end
