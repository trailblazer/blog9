module Auth
  module Lane
    AuthWeb = Trailblazer::Workflow::Collaboration.Lane(json: "app/concepts/auth/json/auth.signup-with-password-0.1.json", lane: "auth.web", start_id: "signup_form?") do
      {
        "Signup form"                 => Subprocess(Auth::Web::Operation::Signup::Present),
        "Forgot pw form"              => Subprocess(Auth::Web::Operation::ForgotPassword::Present),
        "Create user with password!"  => Subprocess(Auth::Web::Operation::CreateUser),
        "Check email"                 => Subprocess(Auth::Web::Operation::CheckEmail),
      } # we have a few tasks, only, mostly we send events. The rendering is done in the controller.
    end # AuthWeb
  end
end
