BlindDateNew::Application.routes.draw do

  devise_for :users

  match '/index', :to => 'pages#index'

  resources :messages

  root :to => 'pages#index'
  #match "/users/index", :to => 'pages#index'

  get "chats/room"
  get  '/chatroom' => 'chats#room', :as => :chat

  resources :pages do
  end
  match '/messages/addMessage'
  match '/messages/countMessage'
end
