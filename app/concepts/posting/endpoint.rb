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

    DefaultMatcher = Trailblazer::Endpoint::Matcher.new(
      success:    ->(*) { raise },
    )

    module Controller
      def trigger(event_label, adapter: Adapter::Model, schema: Posting::Collaboration::Schema, iteration_set: Posting::Collaboration::IterationSet, default_matcher: Posting::Endpoint::DefaultMatcher, **ctx, &block)
        flow_options = {
          event_label: event_label,
          **schema.to_h,
          iteration_set: iteration_set,
          # state_guards:  state_guards, # DISCUSS: we come from the Schema.
          **Blog9::FLOW_OPTIONS,
        }

        ctx = Trailblazer::Context(ctx, {}, Blog9::FLOW_OPTIONS[:context_options]) # DISCUSS: handle this in Endpoint via In() and automatic context creation.

        Trailblazer::Endpoint::Runtime.(
          ctx,
          adapter: adapter,
          default_matcher: default_matcher,
          matcher_context: self,
          flow_options: flow_options,
          &block
        )
      end
    end
  end
end
