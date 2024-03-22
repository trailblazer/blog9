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
        render :create_form, locals: {contract: contract, form_url: update_posting_path, verb: "Correct and update", model: model} }
    end
  end

  def revise_posting_form
    trigger "☝ ⏵︎Revise form", params: params do
      success { |ctx, contract:, model:, **| render :create_form, locals: {contract: contract, form_url: revise_posting_path, verb: "Revise", model: model} }
    end
  end

  def revise_posting
    trigger "☝ ⏵︎Revise", params: params do
      success { |ctx, model:, contract:, **| render :create_form, locals: {contract: contract, form_url: revise_posting_path, verb: "Revise", model: model} }
      failure { |ctx, contract:, model:, **|
        render :create_form, locals: {contract: contract, form_url: revise_posting_path, verb: "Correct and revise", model: model} }
    end
  end

  def request_review
    trigger "☝ ⏵︎Notify approver", params: params do
      success { |ctx, model:, **| redirect_to show_posting_path(model.id) }
    end
  end

  def publish_posting
    trigger "☝ ⏵︎Publish", params: params, controller: self do
      success { |ctx, model:, **| redirect_to show_posting_path(model.id) }
    end
  end

  def archive_posting
    trigger "☝ ⏵︎Archive", params: params do
      success { |ctx, model:, **| redirect_to show_posting_path(model.id) }
    end
  end

  # NOTE: you can also manually trigger the "Delete" link directly. we could show how to add an additional "UI state", not on the model?
  def delete_posting_form
    trigger "☝ ⏵︎Delete? form", params: params do
      success { |ctx, model:, **| render :delete_form, locals: {model: model} }
    end
  end

  # This is an example of how to handle such type of action - no need
  # to explicitly model a "cancel" button like this.
  def cancel_delete_posting
    trigger "☝ ⏵︎Cancel", params: params do
      success { |ctx, model:, **| redirect_to show_posting_path(model.id) }
    end
  end

  def delete_posting
    trigger "☝ ⏵︎Delete", params: params do
      success { |ctx, model:, **| redirect_to create_posting_form_path }
    end
  end

  def show_posting
    render :show, locals: {model: Posting.find(params[:id])} # TODO: either use OP, or endpoint or add show to <ui>?
  end
end
