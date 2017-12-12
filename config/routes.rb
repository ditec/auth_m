AuthM::Engine.routes.draw do
  devise_for :users, {class_name: "AuthM::User", module: :devise, controllers: {:confirmations => 'auth_m/users/confirmations',
                                                                                :invitations => 'auth_m/users/invitations',
                                                                                :passwords => 'auth_m/users/passwords',
                                                                                :registrations => 'auth_m/users/registrations',
                                                                                :sessions => 'auth_m/users/sessions',
                                                                                :unlocks => 'auth_m/users/unlocks'}}

  resources :managements
  
  get 'change_management', to: 'managements#change'

  resources :users do
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
  end
  
  post 'create_user', to: 'users#create_user'


end
