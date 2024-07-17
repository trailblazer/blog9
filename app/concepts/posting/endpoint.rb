require "trailblazer/endpoint"
require "trailblazer/macro/model/find"

class Posting
  module Endpoint
    module Controller
      # DISCUSS: so, #invoke calls #_flow_options, which is the "hook" where we can merge things. Not overly fan of this.
      def _flow_options(flow_options_for_workflow:, **options)
        super.merge(flow_options_for_workflow) # FIXME: does this allow setting alias in {flow_options do ... end} block?
      end

      def trigger(event_label, endpoint: "with process model", schema: Posting::Collaboration::Schema, iteration_set: Posting::Collaboration::IterationSet, **ctx, &block)
        flow_options_for_workflow = {
          event_label: event_label,
          **schema.to_h,
          iteration_set: iteration_set,
          # state_guards:  state_guards, # DISCUSS: we come from the Schema.
          **Blog9::FLOW_OPTIONS,
        }

        # use Endpoint::Controller#invoke as the high-level entry point
        invoke(
          endpoint,

          flow_options_for_workflow: flow_options_for_workflow,
          &block
        )
      end
    end
  end
end
