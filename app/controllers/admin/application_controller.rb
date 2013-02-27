class Admin::ApplicationController < ApplicationController
  before_filter :require_login
  before_filter :check_abilities
  layout 'admin'

  private

  def check_abilities
    redirect_to root_path if cannot? :manage, :all
  end
end
