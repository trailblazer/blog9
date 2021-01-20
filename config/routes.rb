Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/posts/new_form"   => "posts#new_form" # DISCUSS: should we use the Rails way of {resources :posts}?
  post "/posts/create"    => "posts#create", as: :create_post
  get "/posts/view/:id"   => "posts#view", as: :view_post
  get "/posts/edit/:id"   => "posts#edit", as: :edit_post
  patch "/posts/:id/update"    => "posts#update", as: :update_post
  get "/post/:id/request_approval" => "posts#request_approval", as: :request_approval

  get "/my" => "posts#dashboard"
end
