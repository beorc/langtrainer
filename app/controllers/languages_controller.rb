class LanguagesController < ApplicationController

  def set_native
    language = Language.find(params[:id].to_i)
    change_native_language(language)
    redirect_to root_path
  end
end
