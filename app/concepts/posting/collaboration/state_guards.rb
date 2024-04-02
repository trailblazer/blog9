module Posting::Collaboration
  module StateGuards
    Decider = Trailblazer::Workflow::Collaboration::StateGuards.from_user_hash(
      {
        "⏸︎ Approve♦Reject [000]"                   => {guard: ->(ctx, model:, **) { model.state == "⏸︎ Approve♦Reject [000]" }},
        "⏸︎ Archive [100]"                          => {guard: ->(ctx, model:, **) { model.state == "⏸︎ Archive [100]" }},
        "⏸︎ Create [010]"                           => {guard: ->(ctx, model: nil, **) { model.nil? }}, # DISCUSS: changed from generated as this is a no-model state.
        "⏸︎ Create form [000]"                      => {guard: ->(ctx, model: nil, **) { model.nil? }}, # DISCUSS: changed from generated as this is a no-model state.
        "⏸︎ Delete♦Cancel [110]"                    => {guard: ->(ctx, model:, **) { model.state == "⏸︎ Update form♦Delete? form♦Publish [110]" }},
        "⏸︎ Revise [010]"                           => {guard: ->(ctx, model:, **) { model.state == "⏸︎ Revise [010]" }},
        "⏸︎ Revise form [000]"                      => {guard: ->(ctx, model:, **) { model.state == "⏸︎ Revise [010]" }},
        "⏸︎ Revise form♦Notify approver [110]"      => {guard: ->(ctx, model:, **) { model.state == "⏸︎ Revise form♦Notify approver [110]" }},
        "⏸︎ Update [000]"                           => {guard: ->(ctx, model:, **) { ["⏸︎ Update form♦Notify approver [000]", "⏸︎ Update form♦Notify approver [110]", "⏸︎ Update form♦Delete? form♦Publish [110]"].include?(model.state)  }},
        "⏸︎ Update form♦Delete? form♦Publish [110]" => {guard: ->(ctx, model:, **) { model.state == "⏸︎ Update form♦Delete? form♦Publish [110]" }},
        "⏸︎ Update form♦Notify approver [000]"      => {guard: ->(ctx, model:, **) { model.state == "⏸︎ Update form♦Notify approver [000]" }}, # state after Create
        "⏸︎ Update form♦Notify approver [110]"      => {guard: ->(ctx, model:, **) { model.state == "⏸︎ Update form♦Notify approver [110]" }}, # after Update
      },
      state_table: Generated::StateTable,
    )
  end
end
