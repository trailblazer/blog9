# This could be called WriteController or WritingController, too!
class PostsController < ApplicationController::Web
  def dashboard

  end

  endpoint "web:new_form?", find_process_model: false, domain_activity: Trailblazer::Workflow.Advance(scope_workflow_domain_ctx: true, activity: Workflow::Collaboration::WriteWeb)
  endpoint "web:new?!",     find_process_model: false, domain_activity: Trailblazer::Workflow.Advance(scope_workflow_domain_ctx: true, activity: Workflow::Collaboration::WriteWeb)
  endpoint "view",          find_process_model: true, domain_activity: Post::Operation::View # not everything has to be a workflow/part of the state machine.
  endpoint "web:edit_form?", find_process_model: true, domain_activity: Trailblazer::Workflow.Advance(scope_workflow_domain_ctx: true, activity: Workflow::Collaboration::WriteWeb)
  endpoint "web:edit_form_submitted?!", find_process_model: true, domain_activity: Trailblazer::Workflow.Advance(scope_workflow_domain_ctx: true, activity: Workflow::Collaboration::WriteWeb)
  endpoint "web:request_approval?!", find_process_model: true, domain_activity: Trailblazer::Workflow.Advance(scope_workflow_domain_ctx: true, activity: Workflow::Collaboration::WriteWeb)
  endpoint "review:review?", find_process_model: true, domain_activity: Trailblazer::Workflow.Advance(scope_workflow_domain_ctx: true, activity: Workflow::Collaboration::WriteWeb)
  endpoint "review:suggest_changes?", find_process_model: true, domain_activity: Trailblazer::Workflow.Advance(scope_workflow_domain_ctx: true, activity: Workflow::Collaboration::WriteWeb)
  endpoint "review:approve?", find_process_model: true, domain_activity: Trailblazer::Workflow.Advance(scope_workflow_domain_ctx: true, activity: Workflow::Collaboration::WriteWeb)
  endpoint "web:revise_form?", find_process_model: true, domain_activity: Trailblazer::Workflow.Advance(scope_workflow_domain_ctx: true, activity: Workflow::Collaboration::WriteWeb)
  endpoint "web:revise_form_submitted?!", find_process_model: true, domain_activity: Trailblazer::Workflow.Advance(scope_workflow_domain_ctx: true, activity: Workflow::Collaboration::WriteWeb)

  def new_form # new_form
    endpoint "web:new_form?", success: {after: "web:New form"} do |ctx, contract:, **|
      render html: cell(Post::Write::Cell::New, contract, form_url: create_post_path, header: "Create post")
    end
  end

  def create
    endpoint "web:new?!", success: {after: "web:created?"} do |ctx, model:, **|
      redirect_to view_post_path(id: model.id)
    end.Or do |ctx, contract:, **| # render erroring form
      render html: cell(Post::Write::Cell::New, contract, form_url: create_post_path, header: "Create post")
    end
  end

  def view
    endpoint "view" do |ctx, model:, **|
      render html: cell(Post::Write::Cell::View, model)
    end
    # DOCUMENT: how endpoint does the Or() part for you automatically
  end

  def edit # TODO: make one field static so the contract changes
    endpoint "web:edit_form?", success: {after: "web:Edit form"} do |ctx, contract:, model:, **|
      render html: cell(Post::Write::Cell::New, contract, form_url: update_post_path(id: model.id), header: "Edit post")
    end
  end

  def update
    endpoint "web:edit_form_submitted?!", success: {after: "web:updated?"} do |ctx, model:, **| # DOCUMENT: make sure we understand why request_approval?! is the next step if success.
      redirect_to view_post_path(id: model.id)
    end.Or do |ctx, contract:, model:, **| # render erroring form
      render html: cell(Post::Write::Cell::New, contract, form_url: update_post_path(id: model.id), header: "Edit post")
    end
  end

  def request_approval                                            # FIXME: how to configure that?
    endpoint "web:request_approval?!", success: {after: "web:throw-after-request_approval?!"} do |ctx, model:, **|
      redirect_to view_post_path(id: model.id) # TODO: flash message!
    end
    # DISCUSS: test {failure}, when in wrong state
  end

  # {model} is a Review here.
  def review # TODO: rename review to editor
    endpoint "review:review?", success: {after: "review:Review form"}, process_model_class: Review do |ctx, model:, contract:, **|
      render html: cell(Post::Write::Cell::Review, model, review_form: contract)
    end
  end

  def reject
    endpoint "review:suggest_changes?", success: {after: "review:rejected?"}, process_model_class: Review do |ctx, model:, contract:, **|
      render html: cell(Review::Cell::Sent, model)
    end.Or do |ctx, contract:, model:, **| # render erroring form
      render html: cell(Post::Write::Cell::Review, model, review_form: contract)
    end
  end

  def approve
    endpoint "review:approve?", success: {after: "review:approved?"}, process_model_class: Review do |ctx, model:, contract:, **|
      render html: cell(Review::Cell::Sent, model)
    end # there's nothing that (domainically) can go wrong!
  end

  def revise_form
    endpoint "web:revise_form?", success: {after: "web:Revise form"} do |ctx, contract:, model:, review:, **|
      render html: cell(Post::Write::Cell::Revise, contract, form_url: revise_post_path(id: model.id), header: "Revise Post", review: review)
    end
  end

  def revise
    endpoint "web:revise_form_submitted?!", success: {after: "web:revise_updated?"} do |ctx, model:, **|
      redirect_to view_post_path(id: model.id)
    end.Or do |ctx, contract:, model:, **| # render erroring form
      render html: cell(Post::Write::Cell::Revise, contract, form_url: revise_post_path(id: model.id), header: "Revise Post", review: review)
    end
  end

  private def endpoint(event_name, **options)
    super(event_name, **options.merge(event_name: event_name)) # FIXME: add this to {endpoint-workflow}.
  end

  def self.options_for_endpoint(ctx, controller:, **options)
    {
      activity: Workflow::Collaboration::WriteWeb,# FIXME: not used in all cases! USED FOR workflow/advance.rb:65:in `normalize_dictionary'
      process_model:          nil,                              # TODO: this is necessary for Moment and should be documented properly! # workflow/moment.rb:83:in `evaluate_condition'

      process_model_class:    Post,
      process_model_id:       controller.params[:id],
      # encrypted_resume_data:  controller.params[:wf_session],
    }
  end


  # This controller deals with workflows and collaborations.
  def self.controller_arguments_for_endpoint(ctx, **)
    {
      # process_model_from_resume_data: false,
      # cipher_key:                     Rails.application.config.cipher_key,
    }
  end

  directive :options_for_endpoint, method(:controller_arguments_for_endpoint), method(:options_for_endpoint)
end
