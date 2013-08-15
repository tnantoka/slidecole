Slidecole::Application.routes.draw do

  devise_for :users
  root 'welcome#index'
  get 'errors/error_500'

  controller :welcome do
    get :search
  end

  resources :slides, only: [:new, :create, :index] do
    get :blank, on: :collection
    post :preview, on: :collection
  end
  resources :categories, only: [:index, :create, :destroy, :edit, :update] do
  end
  controller :pages, path: 'pages' do
    post :preview
  end
  resources :attachments, only: [:create, :destroy, :index, :show]

  resources :users, path: '', only: [:show] do
    resources :slides, path: '', except: [:new, :create, :index] do
      get :play, on: :member
      get :plain, on: :member
      post :download, on: :member
      post :comments, on: :member, action: :create_comment
    end
    resources :categories, path: 'c', only: [:show, :index] do
      get :uncategorized, on: :collection
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
