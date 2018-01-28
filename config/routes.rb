Rails.application.routes.draw do

  devise_for :users, :controllers => {registrations: 'registrations'}

  get 'about' => 'welcome#about'
  resources :courses
  resources :students
  resources :comments
  get 'attendance' => 'attendances#show'
  patch 'attendance' => 'attendances#update'
  resources :daily_grades
  get 'submit_grades' => 'daily_grades#submit_grades'
  post 'create_grades' => 'daily_grades#create_grades'

  authenticated :user do
    root 'welcome#dashboard', as: :authenticate_root
  end

  root 'welcome#index'

end
