Rails.application.routes.draw do
	devise_for :users, controllers: {
		registrations:'users/registrations'
	}

	get 'users/:id' => 'users#show', as: 'user_profile'
	resources :websites do
    resources :tags
		resources :reviews do
			member do
				put "helpful", to: "reviews#upvote"
				put "unhelpful", to: "reviews#downvote"
			end
		end
		resources :tags
	end
	root 'websites#index'
end
