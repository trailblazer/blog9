module Posting::Operation
  class Revise < Update
    def state(ctx, contract:, **)
      contract.state = "revised, ready to request review"
    end

    class Present < Update::Present # FIXME: fuck, otherwise this is Update::Present and screws the circuit.
    end
  end
end
