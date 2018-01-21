Rails.application.routes.draw do

  devise_for :users, :controllers => {registrations: 'registrations'}

  get 'about' => 'welcome#about'
  resources :courses
  resources :holidays
  resources :class_days
  resources :categories
  resources :students
  resources :comments
  resources :attendances
  resources :grade_categories
  resources :daily_grades

  authenticated :user do
    root 'welcome#dashboard', as: :authenticate_root
  end

  root 'welcome#index'

end
