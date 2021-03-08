require "test_helper"

class AuthOperationTest < Minitest::Spec
  before { User.delete_all; VerifyAccountToken.delete_all }
  include ActionMailer::TestHelper

  module A
    module Auth
    end

    #:op
    # app/concepts/auth/operation/create_account.rb
    module Auth::Operation
      #:steps
      class CreateAccount < Trailblazer::Operation
        step :check_email
        step :passwords_identical?
      #:steps end

        #:check_email
        def check_email(ctx, email:, **)
          email =~ /\A[^,;@ \r\n]+@[^,@; \r\n]+\.[^,@; \r\n]+\z/ # login_email_regexp, stolen from Rodauth.
        end
        #:check_email end

        def passwords_identical?(ctx, password:, password_confirm:, **)
          password == password_confirm
        end
      end
    end
    #:op end

  end

  def it(*)
    yield
  end

  it "what" do
    Auth = A::Auth

    assert_raises ArgumentError do
      #:op-call-missing-kw
      # test/concepts/auth/operation_test.rb
      it "validates email and password" do
        result = Auth::Operation::CreateAccount.({}) # op-interface
        #=> ArgumentError: missing keyword: :email
      end
      #:op-call-missing-kw end
    end

    assert_raises ArgumentError do
      #:op-call-missing-passwords
      # test/concepts/auth/operation_test.rb
      it "validates email and password" do
        result = Auth::Operation::CreateAccount.({email: "yogi@trb.to"}) # here's an email!
        #=> ArgumentError: missing keywords: :password, :password_confirm
        #     app/concepts/auth/operation/create_account.rb:22:in `passwords_identical?'
      end
      #:op-call-missing-passwords end
    end

    output = nil
    output, _ = capture_io do
      assert_raises ArgumentError do
        #:op-call-missing-passwords-wtf
        # test/concepts/auth/operation_test.rb
        it "validates email and password" do
          result = Auth::Operation::CreateAccount.wtf?({email: "yogi@trb.to"})
        end
        #:op-call-missing-passwords-wtf end
      end

    end
    puts output.gsub("AuthOperationTest::A::", "")

    output = nil
    output, _ = capture_io do
      #:op-call-wtf
      # test/concepts/auth/operation_test.rb
      it "validates email and password" do
        result = Auth::Operation::CreateAccount.wtf?(
          {
            email:            "yogi@trb.to",
            password:         "1234",
            password_confirm: "1234",
          }
        )

        assert result.success?
      end
      #:op-call-wtf end

    end
    puts output.gsub("AuthOperationTest::A::", "")

    output = nil
    output, _ = capture_io do
      #:op-call-failure
      # test/concepts/auth/operation_test.rb
      it "validates email and password" do
        result = Auth::Operation::CreateAccount.wtf?(
          {
            email:            "yogi@trb", # invalid email.
            password:         "1234",
            password_confirm: "1234",
          }
        )

        assert result.failure?
      end
      #:op-call-failure end

    end
    puts output.gsub("AuthOperationTest::A::", "")
  end

# introduce {fail}, but wrong
  module B
    module Auth
    end

    #:op-fail
    # app/concepts/auth/operation/create_account.rb
    module Auth::Operation
      class CreateAccount < Trailblazer::Operation
        step :check_email
        fail :email_invalid_msg       # {fail} places steps on the failure track.
        step :passwords_identical?
        fail :passwords_invalid_msg

        #~meth
        def check_email(ctx, email:, **)
          email =~ /\A[^,;@ \r\n]+@[^,@; \r\n]+\.[^,@; \r\n]+\z/
        end

        def passwords_identical?(ctx, password:, password_confirm:, **)
          password == password_confirm
        end
        #~meth end

        def email_invalid_msg(ctx, **)
          ctx[:error] = "Email invalid."
        end

        def passwords_invalid_msg(ctx, **)
          ctx[:error] = "Passwords do not match."
        end
      end
    end
    #:op-fail end
  end

  it "what" do # FIXME: this test currently fails
    Auth = B::Auth

    output = nil
    output, _ = capture_io do
      #:op-wrong-email-wrong
      # test/concepts/auth/operation_test.rb
      it "returns error message for invalid email" do
        result = Auth::Operation::CreateAccount.wtf?(
          {
            email:            "yogi@trb", # invalid email.
            password:         "1234",
            password_confirm: "1234",
          }
        )

        assert result.failure?
        assert_equal "Email invalid.", result[:error]
        #=> Expected: "Email invalid."
        # Actual: "Passwords do not match."
      end
      #:op-wrong-email-wrong end

    end
    puts output.gsub("AuthOperationTest::B::", "")
  end

# wire fail correctly
  module C
    module Auth
    end

    #:op-fail-fast
    # app/concepts/auth/operation/create_account.rb
    module Auth::Operation
      class CreateAccount < Trailblazer::Operation
        step :check_email
        fail :email_invalid_msg, fail_fast: true
        step :passwords_identical?
        fail :passwords_invalid_msg, fail_fast: true
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
        #~meth end
      end
    end
    #:op-fail-fast end
  end

  it "what" do
    Auth = C::Auth

    output = nil
    output, _ = capture_io do
      #:email-wrong
      # test/concepts/auth/operation_test.rb
      it "validates email" do
        result = Auth::Operation::CreateAccount.wtf?(
          {
            email:            "yogi@trb", # invalid email.
            password:         "1234",
            password_confirm: "1234",
          }
        )

        assert result.failure?
        assert_equal "Email invalid.", result[:error]
      end
      #:email-wrong end

    end
    puts output.gsub("AuthOperationTest::C::", "")

    output, _ = capture_io do
      #:password-wrong
      # test/concepts/auth/operation_test.rb
      it "validates passwords" do
        result = Auth::Operation::CreateAccount.wtf?(
          {
            email:            "yogi@trb.to",
            password:         "12345678",
            password_confirm: "1234",
          }
        )

        assert result.failure?
        assert_equal "Passwords do not match.", result[:error]
      end
      #:password-wrong end

    end
    puts output.gsub("AuthOperationTest::C::", "")
  end

# create password
  module D
    module Auth
    end

    #:op-password-hash
    # app/concepts/auth/operation/create_account.rb
    require "bcrypt"

    module Auth::Operation
      class CreateAccount < Trailblazer::Operation
        step :check_email
        fail :email_invalid_msg, fail_fast: true
        step :passwords_identical?
        fail :passwords_invalid_msg, fail_fast: true
        step :password_hash
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
        #~meth end
        def password_hash(ctx, password:, password_hash_cost: BCrypt::Engine::MIN_COST, **) # stolen from Rodauth.
          ctx[:password_hash] = BCrypt::Password.create(password, cost: password_hash_cost)
        end
      end
    end
    #:op-password-hash end
  end

  it "what" do
    Auth = D::Auth

    output = nil
    output, _ = capture_io do
      #:password-hash
      # test/concepts/auth/operation_test.rb
      it "validates input, encrypts the password" do
        result = Auth::Operation::CreateAccount.wtf?(
          {
            email:            "yogi@trb.to", # invalid email.
            password:         "1234",
            password_confirm: "1234",
          }
        )

        assert result.success?
        assert_equal "yogi@trb.to", result[:email]
        # {password_hash} is something like "$2a$04$PgVsy.WbWmJ2tTT6pbDL..zSSQ6YQnlCTjsW8xczE5UeqeQw.EgAK"
        assert_equal 60, result[:password_hash].size
      end
      #:password-hash end

    end
    puts output.gsub("AuthOperationTest::D::", "")
  end

# set state
  module J
    module Auth
    end

    #:op-set-state
    # app/concepts/auth/operation/create_account.rb
    require "bcrypt"

    module Auth::Operation
      class CreateAccount < Trailblazer::Operation
        step :check_email
        fail :email_invalid_msg, fail_fast: true
        step :passwords_identical?
        fail :passwords_invalid_msg, fail_fast: true
        step :password_hash
        step :state

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
        #~meth end
        def state(ctx, **)
          ctx[:state] = "created, please verify account"
        end
      end
    end
    #:op-set-state end
  end


  it "what" do
    Auth = J::Auth

    output = nil
    output, _ = capture_io do
      #:set-state
      # test/concepts/auth/operation_test.rb
      it "validates input, encrypts the password, and sets state" do
        result = Auth::Operation::CreateAccount.wtf?(
          {
            email:            "yogi@trb.to",
            password:         "1234",
            password_confirm: "1234",
          }
        )

        assert result.success?

        assert_equal "created, please verify account", result[:state]
      end
      #:set-state end
    end
  end

# save account
  module E
    module Auth
    end

    #:op-save-account
    # app/concepts/auth/operation/create_account.rb
    require "bcrypt"

    module Auth::Operation
      class CreateAccount < Trailblazer::Operation
        step :check_email
        fail :email_invalid_msg, fail_fast: true
        step :passwords_identical?
        fail :passwords_invalid_msg, fail_fast: true
        step :password_hash
        step :state
        step :save_account

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
        #~meth end
        def save_account(ctx, email:, password_hash:, state:, **)
          user = User.create(email: email, password: password_hash, state: state)
          ctx[:user] = user
        end
      end
    end
    #:op-save-account end
  end

  before { User.delete_all; VerifyAccountToken.delete_all }
  it "what" do
    Auth = E::Auth

    output = nil
    output, _ = capture_io do
      #:save-account
      # test/concepts/auth/operation_test.rb
      it "validates input, encrypts the password, and saves user" do
        result = Auth::Operation::CreateAccount.wtf?(
          {
            email:            "yogi@trb.to",
            password:         "1234",
            password_confirm: "1234",
          }
        )

        assert result.success?

        user = result[:user]
        assert user.persisted?
        assert_equal "yogi@trb.to", user.email
        assert_equal 60, user.password.size
        assert_equal "created, please verify account", user.state
      end
      #:save-account end

      assert_raises ActiveRecord::RecordNotUnique do
        #:save-account-test-unique
        it "doesn't allow two users with same email" do
          options = {
              email:            "yogi@trb.to", # invalid email.
              password:         "1234",
              password_confirm: "1234",
            }

          result = Auth::Operation::CreateAccount.wtf?(options)
          assert result.success?

          result = Auth::Operation::CreateAccount.wtf?(options) # throws an exception!
          assert result.failure?
        end
        #:save-account-test-unique end
      end

    end
    puts output.gsub("AuthOperationTest::E::", "")
  end

  module F
    module Auth
    end

    #:op-save-account-safe
    # app/concepts/auth/operation/create_account.rb
    require "bcrypt"

    module Auth::Operation
      class CreateAccount < E::Auth::Operation::CreateAccount
        # ...

        #:save-account-def
        def save_account(ctx, email:, password_hash:, state:, **)
          begin
            user = User.create(email: email, password: password_hash, state: state)
          rescue ActiveRecord::RecordNotUnique
            ctx[:error] = "Email #{email} is already taken."
            return false
          end

          ctx[:user] = user
        end
        #:save-account-def end
      end
    end
    #:op-save-account-safe end
  end

  it "what" do
    Auth = F::Auth

    output = nil
    output, _ = capture_io do
    #:save-account-safe
      it "doesn't allow two users with same email" do
        options = {
            email:            "yogi@trb.to", # invalid email.
            password:         "1234",
            password_confirm: "1234",
          }

        result = Auth::Operation::CreateAccount.wtf?(options)
        assert result.success?

        result = Auth::Operation::CreateAccount.wtf?(options)
        assert result.failure?
        assert_equal "Email yogi@trb.to is already taken.", result[:error]
        assert_nil result[:user]
      end
      #:save-account-safe end
    end
    puts output.gsub("AuthOperationTest::F::", "")
  end

# verify account token
  module G
    module Auth
    end

    #:op-verify-token
    # app/concepts/auth/operation/create_account.rb
    require "bcrypt"

    module Auth::Operation
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
        #~meth end
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
      end
    end
    #:op-verify-token end
  end

  it "what" do
    Auth = G::Auth

    output = nil
    output, _ = capture_io do
      #:verify-token
      # test/concepts/auth/operation_test.rb
      it "validates input, encrypts the password, saves user, and creates a verify-account token" do
        result = Auth::Operation::CreateAccount.wtf?(
          {
            email:            "yogi@trb.to",
            password:         "1234",
            password_confirm: "1234",
          }
        )

        assert result.success?

        user = result[:user]
        assert user.persisted?
        assert_equal "yogi@trb.to", user.email
        assert_equal 60, user.password.size
        assert_equal "created, please verify account", user.state

        verify_account_token = VerifyAccountToken.where(user_id: user.id)[0]
        # token is something like "aJK1mzcc6adgGvcJq8rM_bkfHk9FTtjypD8x7RZOkDo"
        assert_equal 43, verify_account_token.token.size
      end
      #:verify-token end

      #:verify-token-unique
      class NotRandom
        def self.urlsafe_base64(*)
          "this is not random"
        end
      end

      it "fails when trying to insert the same {verify_account_token} twice" do
        options = {
          email:            "fred@trb.to",
          password:         "1234",
          password_confirm: "1234",
          secure_random:    NotRandom # inject a test dependency.
        }

        result = Auth::Operation::CreateAccount.wtf?(options)
        assert result.success?
        assert_equal "this is not random", result[:verify_account_token]

        result = Auth::Operation::CreateAccount.wtf?(options.merge(email: "celso@trb.to"))
        assert result.failure? # verify account token is not unique.
        assert_equal "Please try again.", result[:error]
      end
      #:verify-token-unique end
    end
    puts output.gsub("AuthOperationTest::G::", "")
  end

# verify account email
  module H
    module Auth
    end

    #:op-verify-email
    # app/concepts/auth/operation/create_account.rb
    require "bcrypt"

    module Auth::Operation
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
    #:op-verify-email end
  end

  it "what" do
    Auth = H::Auth

    output = nil
    output, _ = capture_io do
      assert_emails 1 do
        #:verify-email
        # test/concepts/auth/operation_test.rb
        it "validates input, encrypts the password, saves user,
              creates a verify-account token and send a welcome email" do
          result = Auth::Operation::CreateAccount.wtf?(
            {
              email:            "yogi@trb.to",
              password:         "1234",
              password_confirm: "1234",
            }
          )

          assert result.success?

          user = result[:user]
          assert user.persisted?
          assert_equal "yogi@trb.to", user.email
          assert_equal 60, user.password.size
          assert_equal "created, please verify account", user.state

          assert_match /#{user.id}_.+/, result[:verify_account_token]

          verify_account_token = VerifyAccountToken.where(user_id: user.id)[0]
          # token is something like "aJK1mzcc6adgGvcJq8rM_bkfHk9FTtjypD8x7RZOkDo"
          assert_equal 43, verify_account_token.token.size

          assert_match /\/auth\/verify_account\/#{user.id}_#{verify_account_token.token}/, result[:email].body.to_s
        end
      end
      #:verify-email end
    end
    puts output.gsub("AuthOperationTest::H::", "")
  end

end
