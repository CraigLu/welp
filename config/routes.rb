Rails.application.routes.draw do
	devise_for :users, controllers: {
		registrations:'users/registrations'
	}
  resources :websites
	root 'homes#index'
end
