module Workflow
  module Collaboration
    # The entire process of writing, editing, revising and publishing a blog post.
    WriteWeb = Trailblazer::Workflow.Collaboration(
      lanes: {
        lib: Workflow::Lane::PostLib,
        web:  Workflow::Lane::Write::WriteWeb,
        review:  Workflow::Lane::Write::ReviewWeb,
      }
    ) do
      [
        ["web:new?",                  ->(process_model:) { process_model.nil? }, start(), start(), start()],
        ["web:edit_form?",            ->(process_model:) { process_model.state == "created" }, before("catch-before-?Update!", "catch-before-?Notify approver!"), before("edit_form?", "request_approval?"), start()],
        ["web:edit_form_submitted?",  ->(process_model:) { ["created", "updated"].include?(process_model.state)  }, before("catch-before-?Update!", "catch-before-?Notify approver!"), before("edit_form_submitted?", "edit_cancel?"), start()],
        ["web:request_approval?",  ->(process_model:) { ["created", "updated", "revised, review requested"].include?(process_model.state)  }, before("catch-before-?Update!", "catch-before-?Notify approver!"), before("request_approval?", "edit_form?"), start()],
        ["review:suggest_changes?",  ->(process_model:) { ["waiting for review"].include?(process_model.state)  }, before("catch-before-?Reject!", "catch-before-?Approve!"), before("approved?", "change_requested?"), before("suggest_changes?", "approve?")],
        ["review:approve?",  ->(process_model:) { ["waiting for review"].include?(process_model.state)  }, before("catch-before-?Reject!", "catch-before-?Approve!"), before("approved?", "change_requested?"), before("suggest_changes?", "approve?")],
        ["web:revise_form?",         ->(process_model:) { process_model.state == "edit requested" }, before("catch-before-?Revise!"), before("revise_form?"), before("Start.default")],
        ["web:revise_form_submitted?",         ->(process_model:) { process_model.state == "edit requested" }, before("catch-before-?Revise!"), before("revise_form_submitted?", "revise_form_cancel?"), before("Start.default")],
        ["web:publish?",         ->(process_model:) { process_model.state == "approved, ready to publish" }, before("catch-before-?Publish!", "catch-before-?Delete!", "catch-before-?Update!"), before("publish?", "delete?"), before("Start.default")],
        ["web:archive?",         ->(process_model:) { process_model.state == "published" }, before("catch-before-?Archive!"), before("archive?"), before("Start.default")],
      ]
    end # WriteWeb
  end
end
