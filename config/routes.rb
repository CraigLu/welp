Rails.application.routes.draw do
	devise_for :users, controllers: {
		registrations:'users/registrations'
	}
  resources :websites do
  	resources :reviews
  end
	root 'homes#index'	
end
