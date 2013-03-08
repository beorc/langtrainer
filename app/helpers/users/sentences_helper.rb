module Users::SentencesHelper
  def url_options_for_sentence(sentence)
    if sentence.type == 'Correction'
      return { url: users_correction_path(sentence), method: 'put'}
    end
    { url: users_corrections_path, method: 'post' }
  end
end
