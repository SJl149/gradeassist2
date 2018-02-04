Rails.application.routes.draw do

  devise_for :users, :controllers => {registrations: 'registrations'}

  get 'about' => 'welcome#about'
  resources :courses
  resources :holidays
  resources :class_days
  resources :categories
  resources :students

  get 'students_attendance' => 'attendances#students_attendance'
  patch 'update_attendance' => 'attendances#update_attendance'
  resources :attendances, only: [:update]


  get 'grades' => 'daily_grades#grades'

  resources :daily_grades

  authenticated :user do
    root 'welcome#dashboard', as: :authenticate_root
  end

  root 'welcome#index'

end
