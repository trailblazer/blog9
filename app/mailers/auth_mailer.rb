class AuthMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email
    @email = params[:email]
    @verify_token = params[:verify_token]
    @url  = 'http://example.com/login'
    mail(to: @email, subject: 'Welcome to My Awesome Site')
  end
end
