require "test_helper"

class PostCollaborationTest < Minitest::Spec
  include Trailblazer::Workflow::Testing::AssertPosition

  let(:moment) { Trailblazer::Workflow::Moment::DSL }

  # TODO: abstract to endpoint/test
  def ctx_for(event_name, params: {}, process_model: nil, activity: Workflow::Collaboration::WriteWeb)
    domain_ctx = {params: params}

    ctx = {activity: activity, event_name: event_name, process_model: process_model, domain_ctx: domain_ctx} # TODO: require domain_ctx if scoping on.
  end

  # TODO: abstract to endpoint/test
  def args_for(*args)
    [ctx_for(*args), {context_options: {aliases: {:"contract.default" => :contract}, container_class: Trailblazer::Context::Container::WithAliases, replica_class: Trailblazer::Context::Store::IndifferentAccess}, throw: []}]
  end

  # TODO: abstract to endpoint/test
  # DISCUSS: this assumes that we have an Endpoint/Advance ctx here.
  def assert_position(ctx, *args, collaboration: Workflow::Collaboration::WriteWeb)
    super(ctx[:returned][0].to_h, *args, collaboration: collaboration)
  end

# show how to use Model with {params: id: 1}, but then show how policy does the same
# don't use model ||=

  # advance:
  #   * exception when moment couldn't be computed

  it "what" do
    endpoint = Trailblazer::Workflow.Advance(activity: Workflow::Collaboration::WriteWeb)
    Trailblazer::Endpoint::Protocol::Controller.insert_copy_to_domain_ctx!(endpoint, {:process_model => :model}, before: :invoke_workflow) # in our OPs, we use {ctx[:model]}. In the outer endpoint, we use {:process_model}
    Trailblazer::Endpoint::Protocol::Controller.insert_copy_from_domain_ctx!(endpoint, {:model => :process_model}, after: :invoke_workflow) # in our OPs, we use {ctx[:model]}. In the outer endpoint, we use {:process_model}

# --------- CREATE
  # invalid data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:new?"))

    assert_position ctx, moment.before("catch-before-?Create!"), moment.before("new?")
    assert_exposes ctx[:process_model],
      persisted?: false

  # processable data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:new?", params: {post: {content: text = "That was great!"}}))

  process_model = ctx[:process_model]

    assert_position ctx, moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), moment.before("edit_form?", "request_approval?")
    assert_exposes ctx[:process_model],
      content: text,
      state:   "created"

# --------- UPDATE
  # render edit form
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:edit_form?", process_model: ctx[:process_model]))

    assert_position ctx, moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), moment.before("edit_form_submitted?", "edit_cancel?")
    assert_exposes ctx[:process_model],
      content: text,
      state:   "created"

  # submit invalid data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:edit_form_submitted?", process_model: process_model, params: {post: {content: ""}}))

    assert_position ctx, moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), moment.before("edit_form_submitted?", "edit_cancel?")

  # cancel edit

  # submit processable data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:edit_form_submitted?", process_model: ctx[:process_model], params: {post: {content: new_text = "That was really great!"}}))

    assert_position ctx, moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), moment.before("edit_form?", "request_approval?")
    assert_exposes ctx[:process_model],
      content: new_text,
      state:   "updated"


  end
end
