Rails.application.routes.draw do
	devise_for :users, controllers: {
		registrations:'users/registrations'
	}

	get 'users/:id' => 'users#show', as: 'user_profile'
	resources :websites do
    resources :tags
		resources :reviews
	end
	root 'homes#index'	
end
