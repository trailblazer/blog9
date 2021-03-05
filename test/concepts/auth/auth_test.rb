require "test_helper"

class AuthOperationTest < Minitest::Spec
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

    #:op-pw
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
    #:op-pw end
  end

  it "what" do
    Auth = D::Auth

    output = nil
    output, _ = capture_io do
      #:email-wrong
      # test/concepts/auth/operation_test.rb
      it "validates email" do
        result = Auth::Operation::CreateAccount.wtf?(
          {
            email:            "yogi@trb.to", # invalid email.
            password:         "1234",
            password_confirm: "1234",
          }
        )

        assert result.success?
        # {password_hash} is something like "$2a$04$PgVsy.WbWmJ2tTT6pbDL..zSSQ6YQnlCTjsW8xczE5UeqeQw.EgAK"
        assert_equal 60, result[:password_hash].size
      end
      #:email-wrong end

    end
    puts output.gsub("AuthOperationTest::D::", "")
  end

end
