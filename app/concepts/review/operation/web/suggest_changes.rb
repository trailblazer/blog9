module Review::Operation
  module Web
    class SuggestChanges < Trailblazer::Operation # @requires {model:Review}, {params:Hash}
      step Contract::Build(constant: Post::Operation::Web::Review::Form)
      step Contract::Validate(key: :review)
      step Contract::Persist(method: :sync)
      step :post

      def post(ctx, model:, **)
        ctx[:post] = model.post # DISCUSS: where are we doing this?
      end
    end
  end
end
