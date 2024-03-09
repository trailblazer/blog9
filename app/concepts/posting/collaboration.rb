require "trailblazer/activity/testing"
 implementing_ui = Trailblazer::Activity::Testing.def_steps(:create_form, :ui_create, :update_form, :ui_update, :notify_approver, :reject, :approve, :revise, :publish, :archive, :delete, :delete_form, :cancel, :revise_form,
      :create_form_with_errors, :update_form_with_errors, :revise_form_with_errors, :Approve, :Notify, :Reject)


def noop_task(name)
  ->(ctx, **) do
    true
  end
end


Posting::Collaboration = Trailblazer::Workflow.Collaboration(
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
        "Publish" => implementing_ui.method(:publish),
        "Delete" => implementing_ui.method(:delete),
        "Delete? form" => implementing_ui.method(:delete_form),
        "Cancel" => implementing_ui.method(:cancel),
        "Revise" => implementing_ui.method(:revise),
        "Revise form" => implementing_ui.method(:revise_form),
        "Create form with errors" => implementing_ui.method(:create_form_with_errors),
        "Update form with errors" => implementing_ui.method(:update_form_with_errors),
        "Revise form with errors" => implementing_ui.method(:revise_form_with_errors),
        "Archive" => implementing_ui.method(:archive),

      }
    },
    "reviewer" => { # TODO: no warning about missing config, yet.
      label: "reviewer",
      icon: "☑",
      implementation: {
        "Approve" => implementing_ui.method(:Approve),
        "Notify" => noop_task(:Notify),
        "Reject" => implementing_ui.method(:Reject),
      }

    }
  }
)
