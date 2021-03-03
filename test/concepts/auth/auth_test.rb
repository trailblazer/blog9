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

    #:op-call-missing-kw
    # test/concepts/auth/operation_test.rb
    it "validates email and password" do
      result = Auth::Operation::CreateAccount.({}) # op-interface
      #=> ArgumentError: missing keyword: :email
    end
    #:op-call-missing-kw end



    assert result.success?

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
