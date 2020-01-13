AuthM::Engine.setup do |config|
  config.new_session_captcha = false
  config.new_registration_captcha = false
  config.new_password_captcha = false
  config.new_confirmation_captcha = false
  config.public_users = false
end