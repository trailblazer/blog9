class AuthorController < ApplicationController
  include Posting::Endpoint::Controller

  def create_form
    trigger "☝ ⏵︎Create form" do
      success { |ctx, contract:, **| render locals: {contract: contract, form_url: create_posting_path} }
    end
  end
end
