Rails.application.routes.draw do
	devise_for :users, controllers: {
		registrations:'users/registrations'
	}

	get 'users/:id' => 'users#show'
	resources :websites do
		resources :reviews
	end
	root 'homes#index'	
end
