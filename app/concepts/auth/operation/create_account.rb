module Auth::Operation
  module CreateAccount

    class EmailPasswordBased < Trailblazer::Operation
      step :state
      step :encrypted_password
      step :encrypted_verify_account_token
      step :save
      step :send_verify_account_email

      def state(ctx, model:, **)
        model.state = "password set, please verify email"
      end

      def encrypted_password(ctx, model:, password:, **)
        model.password = password.reverse # TODO: use real encryption/Tyrant/Rodauth
      end

      def save(ctx, model:, **)
        model.save
      end

      def encrypted_verify_account_token(ctx, model:, **)
        model.verify_account_token = "random characters".reverse
      end

      def send_verify_account_email(ctx, model:, **)
        model.email # TODO
      end
    end
  end
end
