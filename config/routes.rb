Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/most_revenue', to: 'most_revenue#index'
        get '/revenue', to: 'revenue#show'
        get '/most_items', to: 'most_items#index'
        get '/:id/items', to: 'items#index'
        get '/:id/invoices', to: 'invoices#index'
        get '/:id/revenue', to: 'revenue#show'
        get '/:id/favorite_customer', to: 'favorite#show'
      end

      namespace :customers do
        get '/:id/favorite_merchant', to: 'favorite#show'
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/:id/invoices', to: 'invoices#index'
        get '/:id/transactions', to: 'transactions#index'
      end

      namespace :invoice_items do
        get '/find', to: 'search#show'
      end 

      resources :merchants, only: [:index, :show]
      resources :customers, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
    end
  end
end
