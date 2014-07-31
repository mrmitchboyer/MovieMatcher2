Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'questions#index'

  get 'movies' => 'movies#index'
  get 'questions' => 'questions#index'
  post 'questions' => 'questions#create', :as => 'enter_question'
end