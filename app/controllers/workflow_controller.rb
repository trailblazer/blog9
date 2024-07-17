class WorkflowController < ApplicationController

  include Trailblazer::Endpoint::Controller.module
  include Posting::Endpoint::Controller

    Template = Class.new(Trailblazer::Endpoint::Protocol) do
      def authenticate(*); true; end
      def policy(*); true; end
    end # Template

    Template::Model = Class.new(Template) do
      step Trailblazer::Activity::Railway::Model::Find(Posting, find_by: :id, not_found_terminus: true), after: :authenticate # FIXME: why do we need FQ constant?
    end

  endpoint do
    ctx do
      {
        params: params,
      }
    end
  end

  endpoint "no model", domain_activity: Trailblazer::Workflow::Advance, protocol: Template do
    {Trailblazer::Activity::Railway.Output(:invalid_event) => Trailblazer::Activity::Railway.Track(:not_authorized)}
  end

  endpoint "with process model", domain_activity: Trailblazer::Workflow::Advance, protocol: Template::Model do
    {Trailblazer::Activity::Railway.Output(:invalid_event) => Trailblazer::Activity::Railway.Track(:not_authorized)}
  end
end
