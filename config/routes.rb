Rails.application.routes.draw do

  apipie
  devise_for :users, :controllers => {:registrations => "registrations",:sessions => 'sessions',:confirmation=> "confirmations"}
  root 'home#index'

  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post 'sign_up' => 'registrations#create'
        post 'sign_in' => 'sessions#create'
        delete 'sign_out' => 'sessions#destroy'
      end
      #profile crud operations
       post 'profile/create' => 'profiles#create'
       put 'profile/:id/update' => 'profiles#update'
       delete 'profile/:id/destroy' => 'profiles#destroy'
       get 'profiles' => 'profiles#index'
       get 'profile/:id'=>"profiles#show"
       # company crud operations
       post 'company/create' => 'companies#create'
       put 'company/:id/update' => 'companies#update'
       delete 'company/:id/destroy' => 'companies#destroy'
       get 'companies' => 'companies#index'
       get 'company/:id' => 'companies#show'
       # job crud operation
       post 'job/create' => 'jobs#create'
       put 'job/:id/update' => 'jobs#update'
       delete 'jobs' => 'jobs#destroy'
       get 'job/:id' => 'jobs#show'
       get 'jobs' => 'jobs#index'
       #price crud operations
       get 'prices'=>'prices#index'
    end
  end



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
