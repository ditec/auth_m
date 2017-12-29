Rails.application.routes.draw do
  mount AuthM::Engine => "/auth_m"

  root to: "welcome#index"
end
