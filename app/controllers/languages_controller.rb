class LanguagesController < ApplicationController

  def set_native
    language_id = params[:id].to_i
    session[:language_id] = language_id
    language = Language.find(language_id)
    if language.russian?
      I18n.locale = :ru
    else
      I18n.locale = :en
    end
    if logged_in?
      current_user.update_attribute 'language_id', language_id
    end
    redirect_to :back
  end
end
