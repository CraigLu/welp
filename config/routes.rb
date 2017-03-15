Rails.application.routes.draw do
	devise_for :users, controllers: {
		registrations:'users/registrations'
	}
	root 'homes#index'
	get 'users/:id' => 'users#show'
end
