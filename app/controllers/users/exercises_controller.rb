class Users::ExercisesController < Users::UserProfileController
  helper_method :collection
  helper_method :resource

  before_filter :authorize_resource, except: [:index]

  has_scope :page, default: 1

  def create
    resource.owner = current_user unless current_user.admin?
    if resource.save
      redirect_to users_exercises_path, notice: t('flash.exercise.create.success')
    else
      render action: 'new'
    end
  end

  def update
    if resource.update_attributes(params[:exercise])
      redirect_to users_exercises_path, notice: t('flash.exercise.update.success')
    else
      render action: 'edit'
    end
  end

  def destroy
    resource.destroy
    redirect_to action: 'index'
  end

  private

  def resource
    exercise_id = params[:id]
    return @exercise ||= Exercise.find(exercise_id) if exercise_id.present?
    @exercise ||= Exercise.new(params[:exercise])
  end

  def collection
    return @exercises unless @exercises.nil?
    @exercises = apply_scopes(Exercise.for_user(current_user))
  end
end
