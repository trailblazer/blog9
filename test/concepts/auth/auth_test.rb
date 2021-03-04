require "test_helper"

class AuthOperationTest < Minitest::Spec
  module A
    module Auth
    end

    #:op
    # app/concepts/auth/operation/create_account/with_email_and_password.rb
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

      # assert result.success?
  end

  it "bla" do
    Auth = A::Auth

    ctx = {
      email: "fred@trb"
    }

    result = Auth::Operation::CreateAccount.(ctx) # op-interface

    assert result.failure?
  end

  it "what" do
    ctx = {
      email: "fred@trb"
    }

    result = Auth::Operation::CreateAccount.wtf?(ctx) # developer support
  end
end
