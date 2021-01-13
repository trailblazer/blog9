Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/posts/new_form" => "posts#new_form" # DISCUSS: should we use the Rails way of {resources :posts}?
  get "/my" => "posts#dashboard"
end
