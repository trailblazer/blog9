require "test_helper"

# TODO: remove {:contract.default}, use alias {:contract}
class AuthTest < Minitest::Spec
  include Trailblazer::Workflow::Testing::AssertPosition

  let(:moment) { Trailblazer::Workflow::Moment::DSL }

  def assert_exposes(asserted, expected_class=nil, **attributes) # FIXME: move to trailblazer-test
    assert_kind_of expected_class, asserted
    super(asserted, **attributes)
  end

  describe "lanes" do
    def ctx_for(ctx)
      ctx
    end

    it "what" do
      ctx = {model: User.new}
      #   .`-- #<Trailblazer::Activity:0x000055ab6825a378>
      # |-- signup_form?
      # |-- Signup form
      # |   |-- Start.default
      # |   `-- End.success
      # `-- suspend-signup_submitted?
      signal, (ctx, _) = Dev.wtf?(Auth::Lane::AuthWeb, args_for(ctx))

      assert_exposes ctx[:"contract.default"], Reform::Form,
        email: nil,
        password: nil,
        password_confirm: nil
    end
  end

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
  skip
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
  end
end
