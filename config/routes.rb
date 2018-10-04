Rails.application.routes.draw do
  root to: 'application#index'

  mount Sidekiq::Web, at: 'sidekiq'

  resource :people, only: [] do 
  	post :mutant
  	get :stats
  end
end
