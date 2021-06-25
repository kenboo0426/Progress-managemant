Rails.application.routes.draw do
  
  root to: 'projects#index'
  resources :users
  resources :projects do
    member do
      get :users
      patch :versions_update
      post :create_outsourcing
      delete :delete_outsourcing
      patch :update_outsourcing
    end
  end
  get "test" => "projects#test"

end
