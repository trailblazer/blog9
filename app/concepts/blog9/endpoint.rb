# require "trailblazer/endpoint"

module Blog9
  class Endpoint
    # The {Protocol} part of an endpoint handles authentication, authorization (policies), finding a process model,
    # and invoking the domain activity.
    #
    # This specific protocol is designed to run a workflow as the domain activity.
    class Protocol < Trailblazer::Endpoint::Protocol
      # Once we got a login, there will be a real {current_user}!
      def authenticate(ctx, request:, **)
        ctx[:current_user] = "Fake User"
      end

      # We will build real policies later.
      # Right now, everything's permitted!
      def policy(ctx, **)
        true
      end

      # Trailblazer::Workflow::Collaboration::Synchronous::Endpoint.insert_success_if!(self) # insert steps after {domain_activity} to find out if the current state machine position is "successful".

      Trailblazer::Endpoint::Protocol::Controller.insert_copy_to_domain_ctx!(self, :current_user => :current_user)
    end # Protocol

    class Adapter < Trailblazer::Endpoint::Adapter::Web
    end # Adapter
  end
end
