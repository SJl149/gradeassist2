class StudentsController < ApplicationController
  def show
    @student = Student.find(params[:id])
    @course = @student.course
  end

  def index
    @students = Student.all.order(:family_name)
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    @course = Course.find(@student.course_id)

    if @student.save
      CreateStudentDailygrades.new(@student, @course).call
      flash[:notice] = "Student was saved successfully."
      redirect_to students_path
    else
      flash.now[:alert] = "Error creating student record."
      render :new
    end
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])

    if @student.update(student_params)
      flash[:notice] = "Student record was updated successfully."
      redirect_to students_path
    else
      flash.now[:alert] = "There was an error updating student record."
      redirect_to students_path
    end
  end

  def destroy
    @student = Student.find(params[:id])

    if @student.destroy
      flash[:notice] = "#{@student.family_name}, #{@student.given_name} was deleted successfully."
      redirect_to students_path
    else
      flash.now[:alert] = "There was an error deleting student record."
      redirect_to students_path
    end
  end

  private

  def student_params
    params.require(:student).permit(:given_name, :family_name, :nickname, :email, :course_id)
  end
end
