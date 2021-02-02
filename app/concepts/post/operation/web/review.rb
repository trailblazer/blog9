module Post::Operation::Web
  class Review < Trailblazer::Operation # DISCUSS: make Review::Operation::New
    class Form < Reform::Form
      property :suggestions
      # validates :suggestions, presence: true
    end

    step Contract::Build(constant: Form)
    step :post

    def post(ctx, model:, **)
      ctx[:post] = model.post # DISCUSS: where are we doing this?
    end
  end # Review
end
