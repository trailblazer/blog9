# Provides generic configurations for controllers hosting web-based endpoints.
class ApplicationController::Web < ApplicationController
  include Trailblazer::Endpoint::Controller.module(dsl: true)

  endpoint adapter:   Blog9::Endpoint::Adapter,
    protocol:         Blog9::Endpoint::Protocol, # with #advance, etc
    domain_activity:  Trailblazer::Workflow.Advance(scope_workflow_domain_ctx: true, activity: Workflow::Collaboration::WriteWeb), # FIXME: this shouldn't be set here!
    scope_domain_ctx: false


  def self.options_for_domain_ctx(ctx, controller:, **)
    {
      params: controller.params,
    }
  end

  def self.options_for_endpoint(ctx, controller:, **)
    {
      request: controller.request,
    }
  end

  directive :options_for_domain_ctx, method(:options_for_domain_ctx)
  directive :options_for_endpoint, method(:options_for_endpoint)
end
