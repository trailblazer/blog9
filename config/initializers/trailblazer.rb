Dev = Trailblazer::Developer # a handy shortcut for {Dev.render()} or {Dev.wtf?()}.

module Blog9
  FLOW_OPTIONS = {
    context_options: {
      aliases: { "contract.default": :contract },
      container_class: Trailblazer::Context::Container::WithAliases,
    }
  }
end

require "trailblazer/endpoint/controller"
