Rails.application.routes.draw do
  mount AuthM::Engine => "/auth_m"
end
