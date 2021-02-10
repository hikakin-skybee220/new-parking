Rails.application.routes.draw do  
  resources :reserves, only: [:new, :show] do
    collection do
      get 'new', to: 'reserves#new'
      post 'create', to: 'reserves#create'
      get 'show', to: 'reserves#show'   
      get 'done', to: 'reserves#done'
    end
  end
  resources :purchase, only: [:index] do
    collection do
      get 'index', to: 'purchase#index'
      post 'pay', to: 'purchase#pay'
      get 'done', to: 'purchase#done'
      get 'history', to: 'purchase#history'
    end
  end
  # devise_for :guests
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
#   devise_for :guests, controllers: {
#   sessions:      'admins/sessions',
#   passwords:     'admins/passwords',
#   registrations: 'admins/registrations'
# }
devise_for :users, controllers: {
  omniauth_callbacks: 'users/omniauth_callbacks',
  sessions:      'users/sessions',
  passwords:     'users/passwords',
  registrations: 'users/registrations'  
}
  devise_scope :user do
    get "passwords/new", :to => "users/passwords#new"
    get "user/select", :to => "users/sessions#detail"
    get "user/show", :to => "users/registrations#show"
    get "guest/signup", :to => "guests/registrations#new"
    get "signup", :to => "users/registrations#new"
    get "login", :to => "users/sessions#new"
    get "logout", :to => "users/sessions#destroy"
  end
  # devise_scope :guest do    
  #   get "guest/:id", :to => "guests/registrations#detail"
  #   get "guest/signup", :to => "guests/registrations#new"
  #   get "guest/login", :to => "guests/sessions#new"
  #   get "guest/logout", :to => "guests/sessions#destroy"
  # end
  resources :card, only: [:new, :show] do
    collection do
      post 'show', to: 'card#show'
      post 'pay', to: 'card#pay'
      post 'delete', to: 'card#delete'
    end
  end

  get "how_user" => "parking#how_user"
  get 'users/index'
  get 'parking/confirmations' => "parking#confirmations"
  get 'parking/start' => "parking#start"
  post 'parking/finish' => "parking#finish"
  post "parking/create" => "parking#create"
  post "/parking_create" => "parking#parking_create"
  get '/' => "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
