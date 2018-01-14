class CoursesController < ApplicationController
  def show
    @course = Course.find(params[:id])
    #@semester = @course.name
    #@students = @course.students.order(:family_name)

    #respond_to do |format|
    #  format.html
    #  format.xlsx
    #end
  end

  def index
    @courses = current_user.courses
  end

  def new
    @course = Course.new
    @course.semesters.build
  end

  def create
    @course = current_user.courses.new(course_params)

    if @course.save
    #  CreateStudentDailygrades.new(@course, current_user).call
      flash[:notice] = "Course was created successfully."
      redirect_to root_path
    else
      flash.now[:alert] = "Error creating the course. Please try again."
      render :new
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])

    if @course.update(course_params)
      flash[:notice] = "Course was updated successfully."
      redirect_to root_path
    else
      flash.now[:alert] = "Error updating course. Please try again."
      render :edit
    end
  end

  def destroy
    @course = Course.find(params[:id])

    if @course.destroy
      flash[:notice] = "#{@course.name} was deleted successfully."
      redirect_to root_path
    else
      flash.now[:alert] = "There was a problem deleting the course."
      redirect_to root_path
    end
  end

  private

  def course_params
    params.require(:course).permit(
      :name,
      semesters_attributes: [:id, :name, :start_date, :end_date, :course_id,
        class_days_attributes: [:id, :day_of_week, :semester_id],
        holidays_attributes: [:id, :name, :class_date, :semester_id]
      ])
  end
end
