require "trailblazer/endpoint"
require "trailblazer/macro/model/find"

class Posting
  module Endpoint
    Template = Class.new(Trailblazer::Endpoint::Protocol) do
      def authenticate(*); true; end
      def policy(*); true; end

    end # Template
    Template::Model = Class.new(Template) do
      step Trailblazer::Activity::Railway::Model::Find(Posting, find_by: :id, not_found_terminus: true), after: :authenticate # FIXME: why do we need FQ constant?
    end

    Protocol = Trailblazer::Endpoint.build_protocol(Template, domain_activity: Trailblazer::Workflow::Advance,
      protocol_block: ->(*) { {Trailblazer::Activity::Railway.Output(:not_authorized) => Trailblazer::Activity::Railway.Track(:not_authorized)} } # TODO: do this automatically!
    )

    Protocol::Model = Trailblazer::Endpoint.build_protocol(Template::Model, domain_activity: Trailblazer::Workflow::Advance,
      protocol_block: ->(*) { {Trailblazer::Activity::Railway.Output(:not_authorized) => Trailblazer::Activity::Railway.Track(:not_authorized)} }
    )



    Adapter = Trailblazer::Endpoint::Adapter.build(Protocol) # build the simplest Adapter we got.
    Adapter::Model = Trailblazer::Endpoint::Adapter.build(Protocol::Model) # build the simplest Adapter we got.
  end
end
