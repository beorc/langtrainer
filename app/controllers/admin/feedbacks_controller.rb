class Admin::FeedbacksController < Admin::ApplicationController
  has_scope :page, default: 1

  def index
    @feedbacks = apply_scopes(Feedback)
  end

  def show
    @feedback = Feedback.find(params[:id])
  end

  def destroy
    @feedback = Feedback.find params[:id]
    @feedback.delete

    redirect_to action: :index
  end
end
