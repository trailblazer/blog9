module Posting::Collaboration
  module StateGuards
    Decider = Trailblazer::Workflow::Collaboration::StateGuards.from_user_hash(
      {
        "⏸︎ Create form"                 => {guard: ->(ctx, model: nil, **) { true }},
        "⏸︎ Create"                      => {guard: ->(ctx, model: nil, **) { true }},
        "⏸︎ Update form♦Notify approver" => {guard: ->(ctx, model:, **) { ["created", "updated", "approved, ready to publish"].include?(model.state) }}, # the number of states equals the number of incoming links in the lifecycle task.
        "⏸︎ Update"                      => {guard: ->(ctx, model:, **) { ["created", "updated", "approved, ready to publish"].include?(model.state) }},  # backtrack all incoming success paths eg. into Update
        "⏸︎ Approve♦Reject"              => {guard: ->(ctx, model:, **) { ["waiting for review"].include?(model.state) }},
        "⏸︎ Delete? form♦Publish"        => {guard: ->(ctx, model:, **) { ["approved, ready to publish"].include?(model.state) }},
        "⏸︎ Delete♦Cancel"               => {guard: ->(ctx, model:, **) { ["approved, ready to publish"].include?(model.state) }},
        "⏸︎ Revise form"                 => {guard: ->(ctx, model:, **) { ["edit requested", "revised, ready to request review"].include?(model.state) }},
        "⏸︎ Archive"                     => {guard: ->(ctx, model:, **) { ["published"].include?(model.state) }},
        "⏸︎ Revise"                      => {guard: ->(ctx, model:, **) { ["edit requested", "revised, ready to request review"].include?(model.state) }},
      },
      state_table: Generated::StateTable,
    )
  end
end
