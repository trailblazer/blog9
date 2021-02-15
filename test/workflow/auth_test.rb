require "test_helper"

# TODO: remove {:contract.default}, use alias {:contract}
class AuthTest < Minitest::Spec
  include Trailblazer::Workflow::Testing::AssertPosition

    # TODO: abstract to endpoint/test
  def args_for(*args)
    [ctx_for(*args), {context_options: {aliases: {:"contract.default" => :contract}, container_class: Trailblazer::Context::Container::WithAliases, replica_class: Trailblazer::Context::Store::IndifferentAccess}, throw: []}]
  end

  # TODO: abstract to endpoint/test
  # DISCUSS: this assumes that we have an Endpoint/Advance ctx here.
  def assert_position(ctx, *args, collaboration: ctx[:activity])
    super(ctx[:returned][0].to_h, *args, collaboration: collaboration)
  end

  let(:moment) { Trailblazer::Workflow::Moment::DSL }

  def assert_exposes(asserted, expected_class=nil, **attributes) # FIXME: move to trailblazer-test
    assert_kind_of expected_class, asserted if expected_class
    super(asserted, **attributes)
  end

  describe "Lib" do
    it "what" do

      auth_collab = Trailblazer::Workflow.Collaboration(
        lanes: {
          lib: Auth::Lane::AuthLib,
          # web:  Workflow::Lane::Write::WriteWeb,
          # review:  Workflow::Lane::Write::ReviewWeb,
        },
        messages: [],
        skip_message_from: [Trailblazer::Activity::Introspect::Graph(Auth::Lane::AuthLib).find("throw-after-?Verify account resend!").task,
          Trailblazer::Activity::Introspect::Graph(Auth::Lane::AuthLib).find("throw-after-?Verify account!").task,
          Trailblazer::Activity::Introspect::Graph(Auth::Lane::AuthLib).find("throw-after-?Create account!").task,
          Trailblazer::Activity::Introspect::Graph(Auth::Lane::AuthLib).find("throw-after-?Reset password!").task,
          Trailblazer::Activity::Introspect::Graph(Auth::Lane::AuthLib).find("throw-after-?Update password!").task
        ]
      ) do
        [
          # ["web:new_form?",              ->(process_model:) { process_model.nil? }, start(), start(), start()],
          ["lib:catch-before-?Create account!", ->(process_model:) { process_model.state.nil? }, start()],
          ["lib:catch-before-?Verify account resend!",      ->(process_model:) { process_model.state == "password set, please verify email" }, before("catch-before-?Verify account!", "catch-before-?Verify account resend!")],
          ["lib:catch-before-?Verify account!",      ->(process_model:) { process_model.state == "password set, please verify email" }, before("catch-before-?Verify account!", "catch-before-?Verify account resend!")],
          ["lib:catch-before-?Reset password!",    ->(process_model:) { ["ready to signin", "password updated, ready to signin"].include?(process_model.state)  }, before("catch-before-?Reset password!", "catch-before-?Login!")],
          ["lib:catch-before-?Update password!",    ->(process_model:) { ["password reset, please change password"].include?(process_model.state) }, before("catch-before-?Update password!", "catch-before-?Reset password!")],
        ]
      end

      # it's easiest to use the Workflow-endpoint interface to use lanes and activities.
      endpoint = Trailblazer::Workflow.Advance(activity: auth_collab, insert_success_if: false)
      Trailblazer::Endpoint::Protocol::Controller.insert_copy_to_domain_ctx!(endpoint, {:process_model => :model}, before: :invoke_workflow) # in our OPs, we use {ctx[:model]}. In the outer endpoint, we use {:process_model}
      Trailblazer::Endpoint::Protocol::Controller.insert_copy_from_domain_ctx!(endpoint, {:model => :process_model}, after: :invoke_workflow) # in our OPs, we use {ctx[:model]}. In the outer endpoint, we use {:process_model}

  # --------- CREATE
      signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint,
        args_for("lib:catch-before-?Create account!", process_model: User.new(email: "yogi@trb.to"), options_for_domain_ctx: {password: "very secret"}, activity: auth_collab))

    # we're expecting a {User} model and set {state,password} and #save
      assert_position ctx, moment.suspend(after: "?Create account!")
      assert_exposes ctx[:process_model], #
        persisted?: true,
        state: "password set, please verify email",
        password: "very secret".reverse,
        verify_account_token: "random characters".reverse

      user = ctx[:process_model]

  # --------- RESEND CONFIRMATION
      signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint,
        args_for("lib:catch-before-?Verify account resend!", process_model: user, options_for_domain_ctx: {}, activity: auth_collab))

      assert_position ctx, moment.suspend(after: "?Create account!")
      assert_exposes ctx[:process_model], #
        persisted?: true,
        state: "password set, please verify email", # DISCUSS: different state name?
        password: "very secret".reverse,
        verify_account_token: "random characters".reverse + " 2"

  # --------- VERIFY/CONFIRM ACCOUNT
        # NOTE: we already found the User associated to the {verify_account_token}.
      signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint,
        args_for("lib:catch-before-?Verify account!", process_model: user, options_for_domain_ctx: {}, activity: auth_collab))

      assert_position ctx, moment.suspend(after: "?Verify account!")
      assert_exposes ctx[:process_model], #
        persisted?: true,
        state: "ready to signin",
        password: "very secret".reverse,
        verify_account_token: nil         # the token expired and is deleted.

  # --------- RESET PASSWORD
      signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint,
        args_for("lib:catch-before-?Reset password!", process_model: user, options_for_domain_ctx: {}, activity: auth_collab))

      assert_position ctx, moment.suspend(after: "?Reset password!")
      assert_exposes ctx[:process_model], #
        persisted?: true,
        state: "password reset, please change password",
        password: nil,
        verify_account_token: "more random".reverse

  # --------- UPDATE PASSWORD
      signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint,
        args_for("lib:catch-before-?Update password!", process_model: user, options_for_domain_ctx: {password: "a new beginning"}, activity: auth_collab))

      assert_position ctx, moment.suspend(after: "?Update password!")
      assert_exposes ctx[:process_model], #
        persisted?: true,
        state: "password updated, ready to signin",
        password: "a new beginning".reverse,
        verify_account_token: nil         # the token expired and is deleted.
    end
  end

  describe "lanes" do
    def ctx_for(ctx)
      ctx
    end

    it "what" do
  # Render signup form
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


      raise signal.inspect
    end
  end

  # TODO: abstract to endpoint/test
  def ctx_for(event_name, params: {}, process_model: nil, activity: Workflow::Collaboration::WriteWeb, options_for_domain_ctx:nil)
    domain_ctx = options_for_domain_ctx || {params: params}

    ctx = {activity: activity, event_name: event_name, process_model: process_model, domain_ctx: domain_ctx,
      success: {after: "web:created?"}, # FIXME: # we don't need success flag here. allow removing/avoiding the {success} steps
    } # TODO: require domain_ctx if scoping on.
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
