HorseRace::Application.routes.draw do
 
  resources :withdraws


  resources :bank_details


  devise_for :members

   resources :races do
     collection do
       get :current_races,:change_status,:view_clients_balance,:contacts,:view_prev_races,:past_races,:view_login
       put :update_status
     end
   end
   resources :tiers do
     collection do
       get :user_balance,:contacts
     end
   end
   root :to => redirect("/home/index")

  devise_scope :users do
    get "/login", :to => "devise/sessions#new", :as => :new_user_session
    get "/logout", :to => "devise/sessions#destroy", :as => :destroy_user_session
  end
 # namespace :admin do
  # resources :users # Have the admin manage them here.
# end
  resources :users do
    get :delete, :on => :member
    get :demo
  end
  

  authenticate :user do
    root :to => "application#index"
  end
  
  devise_for :users, :controllers => {:registrations => "users/registrations" }
  devise_for :users,:skip => [:sessions]
  as :user do
    
    get 'admin/signin' => 'devise/sessions#new', :as => :admin_new_user_session
    get 'signin' => 'devise/sessions#new', :as => :new_user_session
    get 'edit_user'=>'devise/registrations#edit',:as=>:edit_user_registration
    get 'reset_password'=>'users#reset_password',:as=>:reset_password_users
    get 'confirm_password'=>'users#confirm_password'
    get 'sign_up'=>'devise/registrations#new',:as=>:new_user_registration
    post 'signin' => 'devise/sessions#create', :as => :user_session
    get  'user/view_report' => 'users#view_report'
    get  'user/withdraw_request' => 'users#withdraw_request'
    post  'user/withdraw_request' => 'users#withdraw_request'
    get  'user/withdraw_history' => 'users#withdraw_history'
    get  'user/respond_way' => 'users#respond_way'
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end 
  

  resources :users do
    collection do
      get :reset_password,:confirm_password,:update_balance
    end
  end
  
  
     
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   match ':controller(/:action(/:id))(.:format)'
end
