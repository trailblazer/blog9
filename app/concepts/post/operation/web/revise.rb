module Post::Operation::Web
  class Revise < Trailblazer::Operation
    step Contract::Build(constant: Post::Operation::Create::Form) # we could be using our own Form here, adjusted for a web UI.
    step :review

    def review(ctx, model:, **)
      ctx[:review] = model.review # DISCUSS: retrieve review from URL?
    end
  end # Revise
end
