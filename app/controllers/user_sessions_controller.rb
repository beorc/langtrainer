class UserSessionsController < ApplicationController
  skip_before_filter :require_login, :except => [:destroy]

  def new
    @user = User.new
  end

  def destroy
    logout
    redirect_to(root_path, :notice => t('flash.user_sessions.logged_out'))
  end

  private

  def build_meta_tags
    set_meta_tags title: t(:app_name), noindex: true, nofollow: true
  end
end
