AuthM::Engine.routes.draw do
  devise_for :users, {class_name: "AuthM::User", module: :devise, path: 'auth', controllers: {confirmations: 'auth_m/users/confirmations',
                                                                                              invitations: 'auth_m/users/invitations',
                                                                                              passwords: 'auth_m/users/passwords',
                                                                                              registrations: 'auth_m/users/registrations',
                                                                                              sessions: 'auth_m/users/sessions',
                                                                                              unlocks: 'auth_m/users/unlocks',
                                                                                              omniauth_callbacks: 'auth_m/users/omniauth_callbacks' }}
  devise_scope :user do
    post "custom_sign_up" => "users/omniauth_callbacks" 
  end

  delete :unlink_account, to: 'linked_accounts#unlink'

  resources :managements, except: :index do
    post :change, on: :collection
  end

  resources :branches, except: :index do
    post :change, on: :collection
  end

  resources :public_users, except: [:new, :create]

  resources :users do
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
    put :resend_invitation, on: :member
  end

  resources :policy_groups do
    get :load_policies, on: :collection
  end
end