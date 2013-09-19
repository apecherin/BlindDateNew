BlindDateNew::Application.routes.draw do

  devise_for :users

  match '/index', :to => 'pages#index'

  resources :posts

  root :to => 'pages#index'

  get "chats/room"
  get  '/chatroom' => 'chats#room', :as => :chat
end
