Rails.application.routes.draw do
  resources :exchanges, only: %i[create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
