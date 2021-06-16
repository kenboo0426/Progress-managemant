Rails.application.routes.draw do
  
  root to: 'redmine#index'

  get "projects" => "redmine#index"
  get "projects/:project_id" => "redmine#show"
  get "projects/:project_id/edit" => "redmine#edit"
  patch "projects/:project_id" => "redmine#update"
  post "projects/:project_id" => "redmine#create"
  get "test" => "redmine#test"
  get "projects/:project_id/users" => "relationships#index"
  delete "outsourcing_costs/:id" => "redmine#delete_outsourcing"
  patch "project/:project_id" => "redmine#versions_update"
  resources :users
  # resources :relationships

end
