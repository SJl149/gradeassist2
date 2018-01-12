Rails.application.routes.draw do


  devise_for :users, :controllers => {registrations: 'registrations'}

  get 'welcome/dashboard'

  get 'about' => 'welcome#about'

  root 'welcome#index'

end
