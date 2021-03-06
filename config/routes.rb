Rails.application.routes.draw do

  root 'static_pages#top'
  get 'signup', to: 'users#new'
  
  # ログイン機能
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # ログインボタン(管理者、一般ユーザー)
  patch 'login', to: 'sessions#admin_login'
  put 'login', to: 'sessions#general_login'
  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'one_week'
      get 'attendances/edit_one_week'
      patch 'attendances/update_one_week'
      
    end
    resources :attendances, only: :update
  end
end
