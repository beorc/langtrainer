class Users::CoursesController < ApplicationController
  def index
    @users_courses = Users::Course.all
    respond_with(@users_courses)
  end

  def show
    @course = Users::Course.find(params[:id])
    respond_with(@course)
  end

  def new
    @course = Users::Course.new
    respond_with(@course)
  end

  def edit
    @course = Users::Course.find(params[:id])
  end

  def create
    @course = Users::Course.new(params[:course])
    @users_course.save
    respond_with(@course)
  end

  def update
    @course = Users::Course.find(params[:id])
    @users_course.update_attributes(params[:course])
    respond_with(@course)
  end

  def destroy
    @course = Users::Course.find(params[:id])
    @users_course.destroy
    respond_with(@course)
  end
end
