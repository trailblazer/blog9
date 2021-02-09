module Auth::Web
  module Operation
    # Sign up a user with email/password - classic!
    class Signup < Trailblazer::Operation
      class Form < Reform::Form # Keep in mind, a form does not necessarily need a real model, it could be a {Struct} or whatever.
        property :email
        property :password
        property :password_confirm, virtual: true

        validates :email, email: {validate_mx: false} # rails_email_validator
        validate :password_ok?

        def password_ok?
          return if password != nil && password == password_confirm && password.size > 8
          errors.add(:password_confirm, "Passwords don't match")
        end
      end

      class Present < Trailblazer::Operation
        # we don't use Model() here, this is a endpoint thing
        # we also don't run a Policy() check here, also done in the endpoint
        step Contract::Build(constant: Form)
      end
    end
  end
end
