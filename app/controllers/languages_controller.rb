class LanguagesController < ApplicationController

  def set_native
    language_id = params[:id].to_i
    session[:language_id] = language_id
    if logged_in?
      current_user.update_attribute 'language_id', language_id
    end
    redirect_to :back
  end
end
