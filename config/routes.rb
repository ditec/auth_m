AuthM::Engine.routes.draw do
  devise_for :users, {class_name: "AuthM::User", module: :devise, controllers: {:confirmations => 'auth_m/users/confirmations',
                                                                                :invitations => 'auth_m/users/invitations',
                                                                                :passwords => 'auth_m/users/passwords',
                                                                                :registrations => 'auth_m/users/registrations',
                                                                                :sessions => 'auth_m/users/sessions',
                                                                                :unlocks => 'auth_m/users/unlocks',
                                                                                :omniauth_callbacks => 'auth_m/users/omniauth_callbacks' }}
  devise_scope :user do
    post "custom_sign_up" => "users/omniauth_callbacks" 
  end

  resources :managements
  
  post 'change_management', to: 'managements#change'

  resources :people do
    resources :users, only: [:show, :new, :edit, :create, :update, :destroy] do
      post :impersonate, on: :member
      post :generate_new_password_email, on: :member
    end
    post 'create_user', to: 'users#create_user'
  end

  resources :users, only: [:index] do
    post :stop_impersonating, on: :collection
  end

  delete 'unlink_account', to: 'linked_accounts#unlink'

end
