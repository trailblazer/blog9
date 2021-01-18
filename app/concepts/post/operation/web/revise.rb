module Post::Operation::Web
  class Revise < Trailblazer::Operation
    step Contract::Build(constant: Post::Operation::Create::Form) # we could be using our own Form here, adjusted for a web UI.
  end # Revise
end
