class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:about, :index]

  def dashboard
    @courses = current_user.courses
  end

  def index
  end

  def about
  end
end
