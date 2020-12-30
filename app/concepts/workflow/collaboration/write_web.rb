module Workflow
  module Collaboration
Moment =Trailblazer::Workflow::Moment::DSL

    WriteWeb = Trailblazer::Workflow::Collaboration::Schema.new(
      lanes: lanes = {
        lib: Workflow::Lane::PostLib,
        web:  Workflow::Lane::Write::WriteWeb,
        review:  Workflow::Lane::Write::ReviewWeb,
      },
      messages: {
        [:web, "create!"]   => [:lib, "catch-before-?Create!"],
        [:lib, "throw-after-?Create!"]  => [:web, "created?"],
        [:lib, "create_invalid!"]  => [:web, "create_invalid?"],
        [:web, "update!"]   => [:lib, "catch-before-?Update!"],
        [:lib, "throw-after-?Update!"]  => [:web, "updated?"],
        [:lib, "update_invalid!"]  => [:web, "update_invalid?"],
        [:web, "request_approval!"]  => [:lib, "catch-before-?Notify approver!"],
        [:lib, "throw-after-?Notify approver!"]  => [:review, "Start.default"],
        [:review, "suggest_changes!"] => [:lib, "catch-before-?Reject!"],
        [:review, "approve!"] => [:lib, "catch-before-?Approve!"],
        [:lib, "throw-after-?Reject!"] => [:web, "change_requested?"],
        [:lib, "throw-after-?Approve!"] => [:web, "approved?"],
        [:web, "revise_update!"] => [:lib, "catch-before-?Revise!"],
        [:lib, "revise_invalid!"] => [:web, "revise_invalid?"],
        [:lib, "throw-after-?Revise!"] => [:web, "revise_updated?"],
      },
      options: {
        dictionary: Trailblazer::Workflow::Moment.Dictionary(
          lanes,

          ["web:new?",                  ->(process_model:) { process_model.nil? }, Moment.start(), Moment.start(), Moment.start()],
          ["web:edit_form?",            ->(process_model:) { process_model.state == "created" }, Moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), Moment.before("edit_form?", "request_approval?"), Moment.start()],
          ["web:edit_form_submitted?",  ->(process_model:) { ["created", "updated"].include?(process_model.state)  }, Moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), Moment.before("edit_form_submitted?", "edit_cancel?"), Moment.start()],
          ["web:request_approval?",  ->(process_model:) { ["created", "updated"].include?(process_model.state)  }, Moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), Moment.before("request_approval?", "edit_form?"), Moment.start()],
          ["review:suggest_changes?",  ->(process_model:) { ["waiting for review"].include?(process_model.state)  }, Moment.before("catch-before-?Reject!", "catch-before-?Approve!"), Moment.before("approved?", "change_requested?"), Moment.before("suggest_changes?", "approve?")],
          ["web:revise_form?",         ->(process_model:) { process_model.state == "edit requested" }, Moment.before("catch-before-?Revise!"), Moment.before("revise_form?"), Moment.before("Start.default")],
          ["web:revise_form_submitted?",         ->(process_model:) { process_model.state == "edit requested" }, Moment.before("catch-before-?Revise!"), Moment.before("revise_form_submitted?", "revise_form_cancel?"), Moment.before("Start.default")],
          # ["web:view?",           ->(process_model:) { true }, Moment.at("a"), Moment.start()],
          # ["web:duplicate?",      ->(process_model:) { process_model }, Moment.at("a")],
          # ["web:delete?",         ->(process_model:) { process_model }, Moment.at("a")],
          # ["web:confirm_delete?", ->(process_model:) { process_model }, Moment.at("b")],
        )
      }
    )
  end
end
