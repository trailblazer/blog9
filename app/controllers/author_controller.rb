class AuthorController < ApplicationController
  include Posting::Endpoint::Controller

  def create_form
    trigger "☝ ⏵︎Create form", adapter: Posting::Endpoint::Adapter do # we don't need the Model::Find step in Protocol.
      success { |ctx, contract:, model:, **| render locals: {contract: contract, form_url: create_posting_path, verb: "Create", model: model} }
    end
  end

  def create_posting
    trigger "☝ ⏵︎Create", params: params, adapter: Posting::Endpoint::Adapter do # we don't need the Model::Find step in Protocol.
      success { |ctx, model:, **| redirect_to update_posting_form_path(model.id) }
      failure { |ctx, contract:, model:, **|
        render :create_form, locals: {contract: contract, form_url: create_posting_path, verb: "Correct and create", model: model} }
    end
  end

  def update_form
    trigger "☝ ⏵︎Update form", params: params do
      success { |ctx, contract:, model:, **| render :create_form, locals: {contract: contract, form_url: update_posting_path, verb: "Update", model: model} }
    end
  end

  def update_posting
    trigger "☝ ⏵︎Update", params: params do
      success { |ctx, model:, contract:, **| render :create_form, locals: {contract: contract, form_url: update_posting_path, verb: "Update", model: model} }
      failure { |ctx, contract:, model:, **|
        render :create_form, locals: {contract: contract, form_url: update_posting_path, verb: "Correct and create", model: model} }
    end
  end

  def request_review
    trigger "☝ ⏵︎Notify approver", params: params do
      success { |ctx, model:, **| redirect_to show_posting_path(model.id) }
    end
  end

  def show_posting
    render :show, locals: {model: Posting.find(params[:id]), message: "This posting is waiting for a review."} # TODO: either use OP, or endpoint or add show to <ui>?
  end
end
