class CommentsController < ApplicationController

  def index
    @student = Student.find(params[:student])
    @comments = @student.comments.order(:class_date)
  end

  def new
    @class_date = params[:class_date]&.to_date || Date.today
    @student = Student.find(params[:student_id])
    @comment = @student.comments.new
  end

  def create
    @student = Student.find(params[:student])
    @comment = @student.comments.new(comment_pararms)

    if @comment.save
      flash[:notice] = "Comment was created successfully."
      redirect_to root_path
    else
      flash.now[:alert] = "Error creating the comment. Please try again."
      render :new
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_pararms)
      flash[:notice] = "Comment was updated successfully."
      redirect_to root_path
    else
      flash.now[:alert] = "Error updating the comment. Please try again."
      render :edit
    end
  end

  def show
  end

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.destroy
      flash[:notice] = "Comment was deleted successfully."
      redirect_to comments_path
    else
      flash.now[:alert] = "There was an error deleting comment record."
      redirect_to comments_path
    end
  end

  private

  def comment_pararms
    params.require(:comment).permit(:class_date, :content)
  end
end
