class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def dashboard
  end

  def index
  end

  def about
  end
end
