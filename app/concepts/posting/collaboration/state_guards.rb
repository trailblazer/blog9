module Posting::Collaboration
  module StateGuards
    Decider = Trailblazer::Workflow::Collaboration::StateGuards.from_user_hash(
      {
        "⏸︎ Create form"                 => {guard: ->(ctx, model: nil, **) { true }},
        "⏸︎ Create"                      => {guard: ->(ctx, model: nil, **) { true }},
        "⏸︎ Update form♦Notify approver" => {guard: ->(ctx, model:, **) { ["created", "updated", "revised, ready to request review"].include?(model.state) }},
        "⏸︎ Update"                      => {guard: ->(ctx, model:, **) { ["created", "updated"].include?(model.state) }},
        "⏸︎ Approve♦Reject"              => {guard: ->(ctx, model:, **) { ["waiting for review"].include?(model.state) }},
        "⏸︎ Delete? form♦Publish"        => {guard: ->(ctx, model:, **) { ["approved, ready to publish"].include?(model.state) }},
        "⏸︎ Delete♦Cancel"               => {guard: ->(ctx, model:, **) { ["approved, ready to publish"].include?(model.state) }},
        "⏸︎ Revise form"                 => {guard: ->(ctx, model:, **) { ["edit requested"].include?(model.state) }},
        "⏸︎ Archive"                     => {guard: ->(ctx, model:, **) { ["published"].include?(model.state) }},
        "⏸︎ Revise"                      => {guard: ->(ctx, model:, **) { ["edit requested"].include?(model.state) }},
      },
      state_table: Generated::StateTable,
    )
  end
end
