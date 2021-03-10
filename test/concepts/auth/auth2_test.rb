require "test_helper"

# app/concepts/auth/operation/create_account.rb
require "bcrypt"

module Test
  module Auth
  end
end
module Test::Auth::Operation
  class CreateAccount < Trailblazer::Operation
    step :check_email
    fail :email_invalid_msg, fail_fast: true
    step :passwords_identical?
    fail :passwords_invalid_msg, fail_fast: true
    step :password_hash
    step :state
    step :save_account
    step :generate_verify_account_token
    step :save_verify_account_token
    step :send_verify_account_email

    #~meth
    def check_email(ctx, email:, **)
      email =~ /\A[^,;@ \r\n]+@[^,@; \r\n]+\.[^,@; \r\n]+\z/
    end

    def passwords_identical?(ctx, password:, password_confirm:, **)
      password == password_confirm
    end

    def email_invalid_msg(ctx, **)
      ctx[:error] = "Email invalid."
    end

    def passwords_invalid_msg(ctx, **)
      ctx[:error] = "Passwords do not match."
    end
    def password_hash(ctx, password:, password_hash_cost: BCrypt::Engine::MIN_COST, **) # stolen from Rodauth.
      ctx[:password_hash] = BCrypt::Password.create(password, cost: password_hash_cost)
    end

    def state(ctx, **)
      ctx[:state] = "created, please verify account"
    end

    def save_account(ctx, email:, password_hash:, state:, **)
      begin
        user = User.create(email: email, password: password_hash, state: state)
      rescue ActiveRecord::RecordNotUnique
        ctx[:error] = "Email #{email} is already taken."
        return false
      end

      ctx[:user] = user
    end
    def generate_verify_account_token(ctx, secure_random: SecureRandom, **)
      ctx[:verify_account_token] = secure_random.urlsafe_base64(32)
    end

    def save_verify_account_token(ctx, verify_account_token:, user:, **)
      begin
        VerifyAccountToken.create(user_id: user.id, token: verify_account_token)
      rescue ActiveRecord::RecordNotUnique
        ctx[:error] = "Please try again."
        return false
      end
    end
    #~meth end

    def send_verify_account_email(ctx, verify_account_token:, user:, **)
      token_path = "#{user.id}_#{verify_account_token}" # stolen from Rodauth.

      ctx[:verify_account_token] = token_path

      ctx[:email] = AuthMailer.with(email: user.email, verify_token: token_path).welcome_email.deliver_now
    end
  end
end

class Auth2Test < Minitest::Spec
  include ActionMailer::TestHelper

  def it(*)
    User.delete_all; VerifyAccountToken.delete_all; ResetPasswordToken.delete_all; # FIXME!!!!!!!!!!!!!!!!1one

    yield
  end

# verify account / find account
  module I
    module Auth
    end

    #:token-utils
    module Auth
      module TokenUtils # stolen from Rodauth
        module_function

        private def split_token(token)
          token.split("_", 2)
        end

        # https://codahale.com/a-lesson-in-timing-attacks/
        private def timing_safe_eql?(provided, actual)
          provided = provided.to_s
          Rack::Utils.secure_compare(provided.ljust(actual.length), actual) && provided.length == actual.length
        end
      end
    end
    #:token-utils end

    #:op-verify-find
    # app/concepts/auth/operation/verify_account.rb
    module Auth::Operation
      class VerifyAccount < Trailblazer::Operation
        step :extract_from_token
        step :find_verify_account_key
        step :find_user
        step :compare_keys
        step :state # DISCUSS: move outside?
        step :save  # DISCUSS: move outside?
        step :expire_verify_account_token

        def extract_from_token(ctx, verify_account_token:, **)
          id, key = Auth::TokenUtils.split_token(verify_account_token)

          ctx[:id]  = id
          ctx[:key] = key # returns false if we don't have a key.
        end

        def find_verify_account_key(ctx, id:, **)
          ctx[:verify_account_key] = VerifyAccountToken.where(user_id: id)[0]
        end

        def find_user(ctx, id:, **)
          ctx[:user] = User.find_by(id: id)
        end

        def compare_keys(ctx, verify_account_key:, key:, **)
          Auth::TokenUtils.timing_safe_eql?(key, verify_account_key.token) # a hack-proof == comparison.
        end

        def state(ctx, user:, **)
          user.state = "ready to login"
        end

        def save(ctx, user:, **)
          user.save
        end

        def expire_verify_account_token(ctx, verify_account_key:, **)
          verify_account_key.delete
        end
      end
    end
    #:op-verify-find end
  end

  #:valid-create-options
  let(:valid_create_options) {
    {
      email:            "yogi@trb.to",
      password:         "1234",
      password_confirm: "1234",
    }
  }
  #:valid-create-options end

  before { User.delete_all; VerifyAccountToken.delete_all }

  it "what" do
    Auth = I::Auth

    output = nil
    output, _ = capture_io do
      #:verify-find
      # test/concepts/auth/operation_test.rb
      it "allows finding an account from {verify_account_token}" do
        result = Test::Auth::Operation::CreateAccount.wtf?(valid_create_options)
        assert result.success?

        verify_account_token = result[:verify_account_token] # 158_NvMiR6UVglr4pXT_8dqIJB41c0o3lKul2RQc84Tn2kc

        result = Auth::Operation::VerifyAccount.wtf?(verify_account_token: verify_account_token)
        assert result.success?

        user = result[:user]
        assert_equal "ready to login", user.state
        assert_equal "yogi@trb.to", user.email
        assert_nil VerifyAccountToken.where(user_id: user.id)[0]
      end
      #:verify-find end

      #:verify-invalid-id
      it "fails with invalid ID prefix" do
        puts "yo"
        result = Auth::Operation::VerifyAccount.wtf?(verify_account_token: "0_safasdfafsaf")
        assert result.failure?
      end
      #:verify-invalid-id end

      #:verify-invalid-token
      it "fails with invalid token" do
        result = Test::Auth::Operation::CreateAccount.wtf?(valid_create_options)
        assert result.success?

        result = Auth::Operation::VerifyAccount.wtf?(verify_account_token: result[:verify_account_token] + "rubbish")
        assert result.failure?

        result = Auth::Operation::VerifyAccount.wtf?(verify_account_token: "")
        assert result.failure?
      end
      #:verify-invalid-token end

      #:verify-invalid-second
      it "fails second time" do
        result = Test::Auth::Operation::CreateAccount.wtf?(valid_create_options)
        assert result.success?

        result = Auth::Operation::VerifyAccount.wtf?(verify_account_token: result[:verify_account_token])
        assert result.success?
        result = Auth::Operation::VerifyAccount.wtf?(verify_account_token: result[:verify_account_token])
        assert result.failure?
      end
      #:verify-invalid-second end
    end
    puts output.gsub("Auth2Test::I::", "")
  end

# reset password
  module J
    module Auth; end

    #:op-reset
    module Auth::Operation
      class ResetPassword < Trailblazer::Operation
        step :find_user
        pass :reset_password
        step :state
        step :save_user
        step :generate_verify_account_token
        step :save_verify_account_token
        step :send_verify_account_email

        def find_user(ctx, email:, **)
          ctx[:user] = User.find_by(email: email)
        end

        def reset_password(ctx, user:, **)
          user.password = nil
        end

        def state(ctx, user:, **)
          user.state = "password reset, please change password"
        end

        def save_user(ctx, user:, **)
          user.save
        end

        # FIXME: copied from CreateAccount!!!
        def generate_verify_account_token(ctx, secure_random: SecureRandom, **)
          ctx[:verify_account_token] = secure_random.urlsafe_base64(32)
        end

        # FIXME: almost copied from CreateAccount!!!
        def save_verify_account_token(ctx, verify_account_token:, user:, **)
          begin
            ResetPasswordToken.create(user_id: user.id, token: verify_account_token) # VerifyAccountToken => ResetPasswordToken
          rescue ActiveRecord::RecordNotUnique
            ctx[:error] = "Please try again."
            return false
          end
        end

        def send_verify_account_email(ctx, verify_account_token:, user:, **)
          token_path = "#{user.id}_#{verify_account_token}" # stolen from Rodauth.

          ctx[:verify_account_token] = token_path

          ctx[:email] = AuthMailer.with(email: user.email, reset_password_token: token_path).reset_password_email.deliver_now
        end
      end
    #:op-reset end
    end
  end

  it "what" do
    Auth = J::Auth

    output = nil
    output, _ = capture_io do
      it "fails with unknown email" do
        result = Auth::Operation::ResetPassword.wtf?(
          {
            email:            "i_do_not_exist@trb.to",
          }
        )

        assert result.failure?
      end

      assert_emails 2 do
        #:reset
        # test/concepts/auth/operation_test.rb
        it "resets password and sends a reset-password email" do
          # test setup aka "factories":
          result = Test::Auth::Operation::CreateAccount.wtf?(valid_create_options)
          result = I::Auth::Operation::VerifyAccount.wtf?(verify_account_token: result[:verify_account_token])

          # the actual test.
          result = Auth::Operation::ResetPassword.wtf?(
            {
              email:            "yogi@trb.to",
            }
          )

          assert result.success?

          user = result[:user]
          assert user.persisted?
          assert_equal "yogi@trb.to", user.email
          assert_nil user.password                                  # password reset!
          assert_equal "password reset, please change password", user.state

          assert_match /#{user.id}_.+/, result[:verify_account_token]

          reset_password_token = ResetPasswordToken.where(user_id: user.id)[0]
          # token is something like "aJK1mzcc6adgGvcJq8rM_bkfHk9FTtjypD8x7RZOkDo"
          assert_equal 43, reset_password_token.token.size

          assert_match /\/auth\/reset_password\/#{user.id}_#{reset_password_token.token}/, result[:email].body.to_s
        end
        #:reset end

      end
    end
  end

# reset password, refactored.
  module K
    module Auth
      module Activity
        class CreateToken < Trailblazer::Operation
          step :generate_token
          step :save_token

          def generate_token(ctx, secure_random: SecureRandom, **)
            ctx[:token] = secure_random.urlsafe_base64(32)
          end

          def save_token(ctx, token:, user:, token_model_class:, **)
            begin
              token_model_class.create(user_id: user.id, token: token) # token_model_class = VerifyAccountToken or ResetPasswordToken
            rescue ActiveRecord::RecordNotUnique
              ctx[:error] = "Please try again."
              return false
            end
          end
        end # CreateToken
      end
    end

    #:op-reset-sub
    module Auth::Operation
      class ResetPassword < Trailblazer::Operation
        step :find_user
        pass :reset_password
        step :state
        step :save_user
        step Subprocess(Auth::Activity::CreateToken),
          input:  ->(ctx, user:, **) { {token_model_class: ResetPasswordToken, user: user} },
          output: {token: :reset_password_token}
        step :send_verify_account_email

        def find_user(ctx, email:, **)
          ctx[:user] = User.find_by(email: email)
        end

        def reset_password(ctx, user:, **)
          user.password = nil
        end

        def state(ctx, user:, **)
          user.state = "password reset, please change password"
        end

        def save_user(ctx, user:, **)
          user.save
        end

        def send_verify_account_email(ctx, reset_password_token:, user:, **)
          token_path = "#{user.id}_#{reset_password_token}" # stolen from Rodauth.

          ctx[:reset_password_token] = token_path

          ctx[:email] = AuthMailer.with(email: user.email, reset_password_token: token_path).reset_password_email.deliver_now
        end
      end
    end
    #:op-reset-sub end

    module Auth::Operation
      class CreateAccount < Test::Auth::Operation::CreateAccount
        step nil, delete: :generate_verify_account_token
        step nil, delete: :save_verify_account_token
        step Subprocess(Auth::Activity::CreateToken), after: :save_account,
          input:  ->(ctx, user:, **) { {token_model_class: VerifyAccountToken, user: user} },
          output: {token: :verify_account_token}
      end
    end
  end

  it "what" do
    Auth = K::Auth

    output = nil
    output, _ = capture_io do

        #:reset-sub
        # test/concepts/auth/operation_test.rb
        it "resets password and sends a reset-password email" do
          # test setup aka "factories":
          result = Auth::Operation::CreateAccount.wtf?(valid_create_options)
          result = I::Auth::Operation::VerifyAccount.wtf?(verify_account_token: result[:verify_account_token])

          assert_emails 1 do
            # the actual test.
            result = Auth::Operation::ResetPassword.wtf?(
              {
                email:            "yogi@trb.to",
              }
            )

            assert result.success?

            user = result[:user]
            assert user.persisted?
            assert_equal "yogi@trb.to", user.email
            assert_nil user.password                                  # password reset!
            assert_equal "password reset, please change password", user.state

            assert_match /#{user.id}_.+/, result[:reset_password_token]

            reset_password_token = ResetPasswordToken.where(user_id: user.id)[0]
            # token is something like "aJK1mzcc6adgGvcJq8rM_bkfHk9FTtjypD8x7RZOkDo"
            assert_equal 43, reset_password_token.token.size

            assert_match /\/auth\/reset_password\/#{user.id}_#{reset_password_token.token}/, result[:email].body.to_s
          end
        #:reset-sub end

      end
    end
    puts output.gsub("Auth2Test::K::", "")
  end
end
