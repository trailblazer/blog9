Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/posts/new_form"   => "posts#new_form" # DISCUSS: should we use the Rails way of {resources :posts}?
  post "/posts/create"    => "posts#create", as: :create_post
  get "/posts/view/:id"   => "posts#view", as: :view_post
  get "/posts/edit/:id"   => "posts#edit", as: :edit_post
  patch "/posts/:id/update"    => "posts#update", as: :update_post
  get "/posts/:id/request_approval" => "posts#request_approval", as: :request_approval

  get "/reviews/:id"          => "posts#review", as: :review
  get "/reviews/:id/approve"  => "posts#approve", as: :approve_review
  post "/reviews/:id/reject"   => "posts#reject", as: :reject_review

  get "/post/:id/revise" => "posts#revise_form", as: :revise_form
  patch "/posts/:id/revise"    => "posts#revise", as: :revise_post

  get "/my" => "posts#dashboard"
end
