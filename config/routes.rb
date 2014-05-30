Rails.application.routes.draw do
  root :to => "organizations#index"

  resources :organizations, only: [:index, :show, :edit, :update, :new, :create] do
    get 'claim', on: :member
    post 'toggle_hiring', on: :member
  end

  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/auth0", as: "login"

  resources :users, only: [:show, :update, :edit]

  get "/verify_email_callback" => "auth0#verify_email_callback"
  get "/sessions/set" => "sessions#set", as: "set_session"
  get "/sessions/unset" => "sessions#unset", as: "unset_session"

  resources :profile_links, only: [:create, :update, :destroy]

  get 'tags/:tag', to: 'organizations#index', as: :tag
  post 'tag/:organization_id', to: 'tags#create', as: "create_tag"
  delete 'tag/:organization_id/:tag_id', to: 'tags#destroy', as: "destroy_tag"

  post ':organization_id/add_role', to: 'organization_user_roles#create', as: "add_role"
  delete ':organization_id/remove_role/:id', to: 'organization_user_roles#destroy', as: "remove_role"

  resources :activities, only: [:index]

  resources :addresses, only: [:update, :create]
end
