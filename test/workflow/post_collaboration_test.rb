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

    # TODO: test create --> request (without update)
  it "what" do
    endpoint = Trailblazer::Workflow.Advance(activity: Workflow::Collaboration::WriteWeb)
    Trailblazer::Endpoint::Protocol::Controller.insert_copy_to_domain_ctx!(endpoint, {:process_model => :model}, before: :invoke_workflow) # in our OPs, we use {ctx[:model]}. In the outer endpoint, we use {:process_model}
    Trailblazer::Endpoint::Protocol::Controller.insert_copy_from_domain_ctx!(endpoint, {:model => :process_model}, after: :invoke_workflow) # in our OPs, we use {ctx[:model]}. In the outer endpoint, we use {:process_model}

# --------- CREATE
  # invalid data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:new?!"))

    assert_position ctx, moment.before("catch-before-?Create!"), moment.before("new?!"), moment.start()
    assert_exposes ctx[:process_model],
      persisted?: false

  # processable data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:new?!", params: {post: {content: text = "That was great!"}}))

  process_model = ctx[:process_model]

    assert_position ctx, moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), moment.before("edit_form?", "request_approval?!"), moment.start()
    assert_exposes ctx[:process_model],
      content: text,
      state:   "created"

# --------- UPDATE
  # render edit form
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:edit_form?", process_model: ctx[:process_model]))

    assert_position ctx, moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), moment.before("edit_form_submitted?!", "edit_cancel?"), moment.start()
    assert_exposes ctx[:process_model],
      content: text,
      state:   "created"

  # submit invalid data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:edit_form_submitted?!", process_model: process_model, params: {post: {content: ""}}))

    assert_position ctx, moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), moment.before("edit_form_submitted?!", "edit_cancel?"), moment.start()

  # cancel edit

  # submit processable data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:edit_form_submitted?!", process_model: ctx[:process_model], params: {post: {content: new_text = "That was really great!"}}))

    assert_position ctx, moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), moment.before("edit_form?", "request_approval?!"), moment.start()
    assert_exposes ctx[:process_model],
      content: new_text,
      state:   "updated"

# --------- REQUEST APPROVAL
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:request_approval?!", process_model: ctx[:process_model], params: {}))

    assert_position ctx, moment.before("catch-before-?Reject!", "catch-before-?Approve!"), moment.before("approved?", "change_requested?"), moment.before("review?")
    assert_exposes ctx[:process_model],
      content: new_text,
      state:   "waiting for review",
      reviews: Review.where(post_id: ctx[:process_model].id)

  # reject/suggest changes
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("review:suggest_changes?", process_model: ctx[:process_model],
      params: {review: {suggestions: "Line 1 sucks"}}))
    # TODO: validate suggestions, make collection

    assert_position ctx, moment.before("catch-before-?Revise!"), moment.at("suspend-revise_form?"), moment.before("Start.default")
    assert_exposes ctx[:process_model],
      content: new_text,
      state:   "edit requested",
      reviews: Review.where(post_id: ctx[:process_model].id)

    assert_exposes ctx[:domain_ctx][:review], # DISCUSS: make this easily exposable?
      suggestions: "Line 1 sucks"#,
      # state: "waiting for edit"

# wrong: submit web:request_approval?
# wrong: submit web:edit_form?
# wrong: submit web:edit_form_submitted?

# --------- REVISE
  # click "Revise form"
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:revise_form?", process_model: ctx[:process_model], params: {}))

    assert_position ctx, moment.before("catch-before-?Revise!"), moment.before("revise_form_submitted?!", "revise_form_cancel?"), moment.before("Start.default")
    assert_exposes ctx[:process_model],
      content: new_text,
      state:   "edit requested",
      reviews: Review.where(post_id: ctx[:process_model].id)

  # TODO: click "cancel revise"

  # click "Submit revise form"
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:revise_form_submitted?!", process_model: ctx[:process_model], params: {post: {content: "Even better!"}}))

    assert_position ctx, moment.before("catch-before-?Revise!", "catch-before-?Notify approver!"), moment.before("revise_form?", "request_approval?!"), moment.before("Start.default")
    assert_exposes ctx[:process_model],
      content: "Even better!",
      state:   "revised, review requested", # FIXME: "revised, edit requested"
      reviews: Review.where(post_id: ctx[:process_model].id)

  # TODO: invalid revise form

  # Submit to editor (request approval)
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:request_approval?!", process_model: ctx[:process_model], params: {post: {content: "Even better!"}}))

    assert_position ctx, moment.before("catch-before-?Reject!", "catch-before-?Approve!"), moment.before("approved?", "change_requested?"), moment.before("review?")

ctx[:process_model].reload # FIXME: why?
    assert_exposes ctx[:process_model],
      content: "Even better!",
      state:   "waiting for review",
      reviews: Review.where(post_id: ctx[:process_model].id),
      id: ->(asserted:, **) { asserted.reviews.size == 2 }

  # Approve
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("review:approve?", process_model: ctx[:process_model],
      params: {}))

    assert_position ctx, moment.before("catch-before-?Publish!", "catch-before-?Delete!", "catch-before-?Update!"), moment.before("delete?", "publish?!"), moment.before("Start.default")
    assert_exposes ctx[:process_model],
      content: "Even better!",
      state:   "approved, ready to publish",
      reviews: Review.where(post_id: ctx[:process_model].id)

  # Publish
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:publish?!", process_model: ctx[:process_model],
      params: {}))

    assert_position ctx, moment.before("catch-before-?Archive!"), moment.before("archive?!"), moment.before("Start.default")
    assert_exposes ctx[:process_model],
      content: "Even better!",
      state:   "published",
      reviews: Review.where(post_id: ctx[:process_model].id)

  # Archive
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:archive?!", process_model: ctx[:process_model],
      params: {}))

    assert_position ctx, moment.at("success"), moment.at("success"), moment.before("Start.default")
    assert_exposes ctx[:process_model],
      content: "Even better!",
      state:   "archived",
      reviews: Review.where(post_id: ctx[:process_model].id)

  # TODO: delete
  end
end
