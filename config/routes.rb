BlindDateNew::Application.routes.draw do

  devise_for :users

  get '/index', :to => 'pages#index'

  resources :messages

  root :to => 'pages#index'
  #match "/users/index", :to => 'pages#index'

  get 'chats/room'
  get  '/chatroom' => 'chats#room', :as => :chat

  resources :pages

  post '/messages/addMessage'
  post '/messages/countMessage'
  post '/messages/readMessage'
end
