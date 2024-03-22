Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get "postings/new" => "author#create_form", as: :create_posting_form
  post "postings/create" => "author#create_posting", as: :create_posting
  get "postings/:id/update" => "author#update_form", as: :update_posting_form
  patch "postings/:id/update" => "author#update_posting", as: :update_posting
  get "postings/:id/revise" => "author#revise_posting_form", as: :revise_posting_form
  patch "postings/:id/revise" => "author#revise_posting", as: :revise_posting

  get "postings/:id/request_review" => "author#request_review", as: :request_review
  get "postings/:id/review" => "editor#review_posting", as: :review_posting
  get "postings/:id/approve" => "editor#approve_posting", as: :approve_posting
  get "postings/:id/reject" => "editor#reject_posting", as: :reject_posting
  get "postings/:id/publish" => "author#publish_posting", as: :publish_posting
  get "postings/:id/archive" => "author#archive_posting", as: :archive_posting
  get "postings/:id/delete" => "author#delete_posting", as: :delete_posting
  get "postings/:id/cancel_delete" => "author#cancel_delete_posting", as: :cancel_delete_posting
  get "postings/:id/delete_form" => "author#delete_posting_form", as: :delete_posting_form

  get "postings/:id/show" => "author#show_posting", as: :show_posting

  get "editor/dashboard" => "editor#dashboard", as: :editor_dashboard
end
