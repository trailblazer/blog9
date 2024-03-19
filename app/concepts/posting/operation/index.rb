module Posting::Operation
  class Index < Trailblazer::Operation
    step :model!

    def model!(options, *)
      options["model"] = ::Post.all
    end
  end
end
