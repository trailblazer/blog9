# This could be called WriteController or WritingController, too!
class PostsController < ApplicationController::Web
  def dashboard

  end

  endpoint "web:new_form?", find_process_model: false, domain_activity: Trailblazer::Workflow.Advance(scope_workflow_domain_ctx: true, activity: Workflow::Collaboration::WriteWeb)

  def new_form # new_form
    endpoint "web:new_form?", success_before: "web:new?!" do |ctx, **|
      render html: "<div>yo</div>".html_safe
    end
  end

  private def endpoint(event_name, **options)
    super(event_name, **options.merge(event_name: event_name)) # FIXME: add this to {endpoint-workflow}.
  end

  def self.options_for_endpoint(ctx, controller:, **options)
    {
      activity: Workflow::Collaboration::WriteWeb,# FIXME: not used in all cases! USED FOR workflow/advance.rb:65:in `normalize_dictionary'
      process_model:          nil,                              # TODO: this is necessary for Moment and should be documented properly! # workflow/moment.rb:83:in `evaluate_condition'


      # suspend_activity: Diagram::Workflow::Web, # FIXME: not used in all cases!

      # errors:                 Trailblazer::Endpoint::Adapter::API::Errors.new,
      # error_representer:      FunctionController::Ep_FIXME::ErrorsRepresenter,
      # request:                controller.request,

      # process_model_class:    Diagram,
      # process_model_id:       controller.params[:id],
      # encrypted_resume_data:  controller.params[:wf_session],

      # collaboration: Diagram::Collaboration::Web,
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
