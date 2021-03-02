module Auth
  module Lane
    AuthLib = Trailblazer::Workflow::Collaboration.Lane(json: "app/concepts/auth/json/auth.signup-with-password-0.1.json", lane: "auth.lib", start_id: "catch-before-?Create account!") do
      {
        "?Create account!" => Subprocess(Auth::Operation::CreateAccount::EmailPasswordBased),
        "?Verify account resend!"                   => Subprocess(Auth::Operation::ResetVerifyToken),
        "?Verify account!"                   => Subprocess(Auth::Operation::VerifyAccount),
        "?Reset password!"                  => Subprocess(Auth::Operation::ResetPassword),
        "?Update password!"                 => Subprocess(Auth::Operation::UpdatePassword),
        "?Login!"                 => Subprocess(Trailblazer::Operation), # TODO: implement me!
        "?Logout!"                 => Subprocess(Trailblazer::Operation), # TODO: implement me!
      } # we have a few tasks, only, mostly we send events. The rendering is done in the controller.
    end # AuthWeb
  end
end
