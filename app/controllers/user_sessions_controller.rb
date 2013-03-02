class UserSessionsController < ApplicationController
  skip_before_filter :require_login, :except => [:destroy]
  before_filter :build_meta_tags

  def new
    @user = User.new
  end

  def destroy
    logout
    redirect_to(root_path, :notice => 'Logged out!')
  end

  private

  def build_meta_tags
    set_meta_tags noindex: true, nofollow: true
  end
end
