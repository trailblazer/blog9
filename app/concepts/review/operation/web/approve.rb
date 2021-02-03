module Review::Operation
  module Web
    class Approve < Trailblazer::Operation # @requires {model:Review}, {params:Hash}
      step :post

      def post(ctx, model:, **)
        ctx[:post] = model.post # DISCUSS: where are we doing this?
      end
    end
  end
end
