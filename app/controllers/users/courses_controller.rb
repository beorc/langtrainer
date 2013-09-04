class Users::CoursesController < Users::UserProfileController
  respond_to :html
  responders :flash

  helper_method :collection
  helper_method :resource

  before_filter :authorize_resource

  def create
    resource.owner = current_user unless current_user.admin?
    resource.save
    respond_with(@course)
  end

  def update
    resource.update_attributes(params[:course])
    respond_with(resource)
  end

  def destroy
    resource.destroy
    respond_with(resource)
  end

  private

  def resource
    course_id = params[:id]
    return @course ||= Course.find(course_id) if course_id.present?
    @course ||= Course.new(params[:course])
  end

  def collection
    return @course unless @course.nil?
    @course = apply_scopes(Course.for_user(current_user))
  end
end
