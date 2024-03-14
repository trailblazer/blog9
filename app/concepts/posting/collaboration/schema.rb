def noop_task(name)
  ->(ctx, **) do
    true
  end
end


module Posting::Collaboration
  Schema = Trailblazer::Workflow.Collaboration(
    json_file: "app/concepts/posting/posting-v1.json",
    lanes: {
      "article moderation"    => {
        label: "lifecycle",
        icon:  "⛾",
        implementation: {
          "Create" => Trailblazer::Activity::Railway.Subprocess(Post::Operation::Create),
          "Update" => Trailblazer::Activity::Railway.Subprocess(Post::Operation::Update),
          "Approve" => Trailblazer::Activity::Railway.Subprocess(Post::Operation::Approve),
          "Notify approver" => Trailblazer::Activity::Railway.Subprocess(Post::Operation::NotifyEditor),
          "Revise" => Trailblazer::Activity::Railway.Subprocess(Post::Operation::Revise),
          "Reject" => Trailblazer::Activity::Railway.Subprocess(Post::Operation::Reject),
          "Publish" => Trailblazer::Activity::Railway.Subprocess(Post::Operation::Publish),
          "Archive" => Trailblazer::Activity::Railway.Subprocess(Post::Operation::Archive),
          "Delete" => Trailblazer::Activity::Railway.Subprocess(Post::Operation::Delete),
        }
      },
      "<ui> author workflow"  => {
        label: "UI",
        icon:  "☝",
        implementation: {
          "Create form" => Trailblazer::Activity::Railway.Subprocess(Post::Operation::Create::Present),
          "Create" => noop_task(:ui_create),
          "Update form" => Trailblazer::Activity::Railway.Subprocess(Post::Operation::Update::Present),
          "Update" => noop_task(:ui_update),
          "Notify approver" => noop_task(:notify_approver),
          "Publish" => noop_task(:publish),
          "Delete" => noop_task(:delete),
          "Delete? form" => Trailblazer::Activity::Railway.Subprocess(Web::Operation::DeleteForm),
          "Cancel" => noop_task(:cancel),
          "Revise" => noop_task(:revise),
          "Revise form" => Trailblazer::Activity::Railway.Subprocess(Post::Operation::Revise::Present),
          "Create form with errors" => noop_task(:create_form_with_errors),
          "Update form with errors" => noop_task(:update_form_with_errors), # we already have {ctx[:contract]} from {lifecycle:Create} here.
          "Revise form with errors" => noop_task(:revise_form_with_errors),
          "Archive" => noop_task(:archive),

        }
      },
      "reviewer" => { # TODO: no warning about missing config, yet.
        label: "reviewer",
        icon: "☑",
        implementation: {
          "Approve" => noop_task(:Approve),
          "Notify" => noop_task(:Notify),
          "Reject" => noop_task(:Reject),
        }

      }
    }, # :lanes
    state_guards: Posting::Collaboration::StateGuards::Decider,
  )
end
