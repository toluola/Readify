Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post  'login', to: 'users#login'
      post "signup", to: "users#create"
      get "feeds", to: "books#index"
      post "review", to: "books#review"
      post "books:book_id/like", to: "likes#create"
      delete "books:book_id/unlike", to: "likes#destroy"
      get "books/:book_id", to: "books#show"
      post "booklists", to "book_list#create"
      get "booklists", to "book_list#index"
      get "booklists/:book_id" to "book_list#show"
      delete "booklists/:book_id" to "book_list#destroy"
      post "booklists/:booklist_id/book" to "book_list_books#create"
      delete "booklists/:book_id/book" to "book_list_books#destroy"
    end
  end

  get '/books/:id', to: 'feeds#show'
  get 'signup', to: 'signup#index'
  get 'feeds', to: 'feeds#index'
  root 'loginpage#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
