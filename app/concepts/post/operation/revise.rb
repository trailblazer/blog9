module Post::Operation
  class Revise < Update
    def state(ctx, contract:, **)
      contract.state = "revised, review requested"
    end
  end
end
