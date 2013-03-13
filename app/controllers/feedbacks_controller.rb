class FeedbacksController < ApplicationController

  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.user = current_user if logged_in?
    if @feedback.save
      redirect_to root_path, notice: t('flash.feedback.create.success')
    else
      render action: :new
    end
  end
end
