module Workflow
  module Collaboration
Moment =Trailblazer::Workflow::Moment::DSL

    WriteWeb = Trailblazer::Workflow::Collaboration::Schema.new(
      lanes: lanes = {
        lib: Workflow::Lane::PostLib,
        web:  Workflow::Lane::Write::WriteWeb
      },
      messages: {
        [:web, "create!"]   => [:lib, "create?"],
        [:lib, "created!"]  => [:web, "created?"],
      },
      options: {
        dictionary: Trailblazer::Workflow::Moment.Dictionary(
          lanes,

          ["web:new?",            ->(process_model:) { true }, Moment.start()],
          # ["web:view?",           ->(process_model:) { true }, Moment.at("a")],
          # ["web:duplicate?",      ->(process_model:) { process_model }, Moment.at("a")],
          # ["web:delete?",         ->(process_model:) { process_model }, Moment.at("a")],
          # ["web:confirm_delete?", ->(process_model:) { process_model }, Moment.at("b")],
        )
      }
    )
  end
end
