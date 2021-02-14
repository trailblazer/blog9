module Auth
  module Lane
    AuthLib = Trailblazer::Workflow::Collaboration.Lane(json: "app/concepts/auth/json/auth.signup-with-password-0.1.json", lane: "auth.lib", start_id: "Auth: encrypted pw, confirm token") do
      {
        "Auth: encrypted pw, confirm token" => Subprocess(Auth::Operation::Signup::EmailPasswordBased),
        "?Reset password!"                  => Subprocess(Auth::Operation::ResetPassword),
        "?Reset confirm!"                   => Subprocess(Auth::Operation::ResetVerifyToken),
        "?Confirm email!"                   => Subprocess(Auth::Operation::VerifyAccount),
        "?Update password!"                 => Subprocess(Auth::Operation::UpdatePassword),
      } # we have a few tasks, only, mostly we send events. The rendering is done in the controller.
    end # AuthWeb
  end
end
