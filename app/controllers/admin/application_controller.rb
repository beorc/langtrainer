class Admin::ApplicationController < ApplicationController
  included do
    before_filter :require_login
    before_filter :check_abilities
    layout 'admin'
  end

  private

  def check_abilities
    redirect_to root_path if cannot? :manage, :all
  end
end
