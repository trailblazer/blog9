require "test_helper"

class PostCollaborationTest < Minitest::Spec
  include Trailblazer::Workflow::Testing::AssertPosition

  let(:moment) { Trailblazer::Workflow::Moment::DSL }

  # TODO: abstract to endpoint/test
  def ctx_for(event_name, params: {}, process_model: nil, activity: Workflow::Collaboration::WriteWeb, options_for_domain_ctx:nil)
    domain_ctx = options_for_domain_ctx || {params: params}

    ctx = {activity: activity, event_name: event_name, process_model: process_model, domain_ctx: domain_ctx,
      success: {after: "web:created?"}, # FIXME: # we don't need success flag here. allow removing/avoiding the {success} steps
    } # TODO: require domain_ctx if scoping on.
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
  # new form
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:new_form?"))

    assert_position ctx, moment.start(), moment.before("new?!"), moment.start()
    assert_exposes ctx[:process_model], #
      persisted?: false
    assert_exposes ctx[:domain_ctx][:contract], # DISCUSS: do we want {:contract} in the endpoint_ctx?
      content: nil

  # invalid data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:new?!"))

    assert_position ctx, moment.before("catch-before-?Create!"), moment.before("new?!"), moment.start()
    assert_exposes ctx[:process_model],
      persisted?: false

  # processable data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:new?!", params: {post: {content: text = "That was great!"}}))

  process_model = ctx[:process_model]
  post          = process_model

    assert_position ctx, moment.suspend(after: "?Create!"), moment.before("edit_form?", "request_approval?!"), moment.start()
    assert_exposes ctx[:process_model],
      content: text,
      state:   "created"

# --------- UPDATE
  # render edit form
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:edit_form?", process_model: ctx[:process_model]))

    assert_position ctx, moment.suspend(after: "?Create!"), moment.before("edit_form_submitted?!", "edit_cancel?"), moment.start()
    assert_exposes ctx[:process_model],
      content: text,
      state:   "created"

  # submit invalid data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:edit_form_submitted?!", process_model: process_model, params: {post: {content: ""}}))

    assert_position ctx, moment.suspend(after: "?Create!"), moment.before("edit_form_submitted?!", "edit_cancel?"), moment.start()

  # cancel edit

  # submit processable data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:edit_form_submitted?!", process_model: ctx[:process_model], params: {post: {content: new_text = "That was really great!"}}))

    assert_position ctx, moment.suspend(after: "?Update!"), moment.before("edit_form?", "request_approval?!"), moment.start()
    assert_exposes ctx[:process_model],
      content: new_text,
      state:   "updated"

# --------- REQUEST APPROVAL
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:request_approval?!", process_model: ctx[:process_model], params: {}))

    assert_position ctx, moment.suspend(after: "?Notify approver!"), moment.before("approved?", "change_requested?"), moment.before("review?")
    assert_exposes ctx[:process_model].reload,
      content: new_text,
      state:   "waiting for review",
      reviews: ->(asserted:, **) { asserted.reviews.size == 1 }

# --------- Review form
    review = ctx[:process_model].reviews[0]

    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("review:review?", process_model: review, params: {}))

    assert_position ctx, moment.suspend(after: "?Notify approver!"), moment.before("approved?", "change_requested?"), moment.suspend(after: "Review form", last_node_id: "Review form")
    # {process_model} is a {Review}
    assert ctx[:domain_ctx][:model].is_a?(Review)
    assert_exposes ctx[:process_model],
      post_id: post.id,
      persisted?: true,
      suggestions: nil

  # reject/suggest changes

    # process_model is Review
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("review:suggest_changes?", process_model: review,
      params: {review: {suggestions: "Line 1 sucks"}}))
    # TODO: validate suggestions, make collection

    # assert_position ctx, moment.suspend(after: "?Reject!"), moment.at("suspend-revise_form?"), moment.before("Start.default")
    assert_position ctx, moment.suspend(after: "reject!", last_node_id: "reject!"), moment.at("suspend-revise_form?"), moment.before("Start.default")
    assert ctx[:domain_ctx][:model].is_a?(Review)
    assert ctx[:process_model].is_a?(Review) # DISCUSS: because we do {    |-- copy_[:process_model]_from_domain_ctx[:model]}
    assert ctx[:domain_ctx][:post].is_a?(Post)
    assert_exposes ctx[:domain_ctx][:post],
      content: new_text,
      state:   "edit requested",
      reviews: ->(asserted:, **) { asserted.reviews.size == 1 }

    assert_exposes ctx[:domain_ctx][:model], # DISCUSS: make this easily exposable?
      suggestions: "Line 1 sucks"#,
      # state: "waiting for edit"


# wrong: submit web:request_approval?
# wrong: submit web:edit_form?
# wrong: submit web:edit_form_submitted?

# --------- REVISE
  # click "Revise form"
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:revise_form?", process_model: post, params: {}))

    assert_position ctx, moment.suspend(after: "reject!", last_node_id: "reject!"), moment.before("revise_form_submitted?!", "revise_form_cancel?"), moment.before("Start.default")
    assert ctx[:domain_ctx][:model].is_a?(Post)
    assert_exposes ctx[:process_model],
      content: new_text,
      state:   "edit requested",
      reviews: Review.where(post_id: ctx[:process_model].id)

  # TODO: click "cancel revise"

  # click "Submit revise form"
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:revise_form_submitted?!", process_model: ctx[:process_model], params: {post: {content: "Even better!"}}))

    assert_position ctx, moment.suspend(after: "?Revise!"), moment.before("revise_form?", "request_approval?!"), moment.before("Start.default")
    assert_exposes ctx[:process_model],
      content: "Even better!",
      state:   "revised, review requested", # FIXME: "revised, edit requested"
      reviews: Review.where(post_id: ctx[:process_model].id)

  # TODO: invalid revise form

  # Submit to editor (request approval)
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:request_approval?!", process_model: ctx[:process_model], params: {post: {content: "Even better!"}}))

    assert_position ctx, moment.suspend(after: "?Notify approver!"), moment.before("approved?", "change_requested?"), moment.before("review?")

    assert_exposes ctx[:process_model].reload, # FIXME: why?
      content: "Even better!",
      state:   "waiting for review",
      reviews: Review.where(post_id: ctx[:process_model].id),
      id: ->(asserted:, **) { asserted.reviews.size == 2 }

    assert ctx[:domain_ctx][:review].is_a?(Review)

  # Approve
    review = ctx[:domain_ctx][:review]

    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("review:approve?", process_model: review, params: {}))

    assert_position ctx, moment.suspend(after: "approve!", last_node_id: "approve!"), moment.before("delete?", "publish?!"), moment.before("Start.default")
    assert ctx[:domain_ctx][:model].is_a?(Review)
    assert_exposes ctx[:domain_ctx][:model], # DISCUSS: make this easily exposable?
      suggestions: nil

    assert_exposes ctx[:domain_ctx][:post],
      content: "Even better!",
      state:   "approved, ready to publish",
      slug:    nil,
      reviews: ->(asserted:, **) { asserted.reviews.size == 2 }

  # Publish
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:publish?!", process_model: ctx[:domain_ctx][:post],
      options_for_domain_ctx: {
        controller: Rails.application.routes.url_helpers, # for {#slug_for}
      }
    ))

    assert_position ctx, moment.suspend(after: "?Publish!"), moment.before("archive?!"), moment.before("Start.default")
    assert_exposes ctx[:process_model],
      content: "Even better!",
      state:   "published",
      slug:    "/posts/even-better-",
      reviews: Review.where(post_id: ctx[:process_model].id)

  # Archive
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:archive?!", process_model: ctx[:process_model],
      params: {}))

    assert_position ctx, moment.at("success"), moment.at("success"), moment.before("Start.default")
    assert_exposes ctx[:process_model],
      content: "Even better!",
      state:   "archived",
      slug:    "/posts/even-better-",
      reviews: Review.where(post_id: ctx[:process_model].id)

  # TODO: delete
  end
end
