class ApplicationController < ActionController::Base
  #  These are our application-specific runtime options.
  def self.default_options_for_endpoint(ctx, **)
    {
      flow_options: {
        throw:           [],
        context_options: {
          container_class: Trailblazer::Context::Container::WithAliases,
          aliases: {"contract.default"=>:contract}
        },
      },
    }
  end

  def self.options_for_block_options(ctx, **)
    {
      invoke: Trailblazer::Developer.method(:wtf?) # this will invoke the endpoint and thus the domain activity or workflow using #wtf?
    }
  end

  include Trailblazer::Endpoint::Controller.module(application_controller: true)

  directive :options_for_block_options, method(:options_for_block_options)
  directive :options_for_endpoint,      method(:default_options_for_endpoint)
end
