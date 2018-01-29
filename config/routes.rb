Rails.application.routes.draw do

  devise_for :users, :controllers => {registrations: 'registrations'}

  get 'about' => 'welcome#about'
  resources :courses
  resources :students
  resources :comments
  get 'attendance' => 'attendances#show'
  patch 'attendance' => 'attendances#update'
  get 'submit_grades' => 'daily_grades#submit_grades'

  resources :daily_grades do
    collection do
      match 'grades_collection', via: [:post]
    end
  end

  authenticated :user do
    root 'welcome#dashboard', as: :authenticate_root
  end

  root 'welcome#index'

end
