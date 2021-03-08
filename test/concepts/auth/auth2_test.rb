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
  def it(*)
    User.delete_all; VerifyAccountToken.delete_all # FIXME!!!!!!!!!!!!!!!!1one

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

end
