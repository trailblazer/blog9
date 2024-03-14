module Posting::Collaboration
  module StateGuards
    Decider = Trailblazer::Workflow::Collaboration::StateGuards.from_user_hash(
      {
        "⏸︎ Create form"                 => {guard: ->(ctx, model: nil, **) { true }},
        "⏸︎ Create"                      => {guard: ->(ctx, model: nil, **) { true }},
        "⏸︎ Update form♦Notify approver" => {guard: ->(ctx, model:, **) { ["created", "updated"].include?(model.state) }},
        "⏸︎ Update"                      => {guard: ->(ctx, model:, **) { raise "implement me!" }},
        "⏸︎ Approve♦Reject"              => {guard: ->(ctx, model:, **) { ["waiting for review"].include?(model.state) }},
        "⏸︎ Delete? form♦Publish"        => {guard: ->(ctx, model:, **) { raise "implement me!" }},
        "⏸︎ Revise form"                 => {guard: ->(ctx, model:, **) { raise "implement me!" }},
        "⏸︎ Delete♦Cancel"               => {guard: ->(ctx, model:, **) { raise "implement me!" }},
        "⏸︎ Archive"                     => {guard: ->(ctx, model:, **) { raise "implement me!" }},
        "⏸︎ Revise"                      => {guard: ->(ctx, model:, **) { raise "implement me!" }},
      },
      state_table: Generated::StateTable,
    )
  end
end
