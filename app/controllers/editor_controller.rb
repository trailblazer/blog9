class EditorController < ApplicationController
  include Posting::Endpoint::Controller

  def review_posting
    # trigger "☝ ⏵︎Create form", adapter: Posting::Endpoint::Adapter do # we don't need the Model::Find step in Protocol.
    #   success { |ctx, contract:, model:, **| render locals: {contract: contract, form_url: create_posting_path, verb: "Create", model: model} }
    # end
    render :review_posting, locals: {model: Posting.find(params[:id])} # TODO: either use OP, or endpoint or add show to <ui>?
  end
end
