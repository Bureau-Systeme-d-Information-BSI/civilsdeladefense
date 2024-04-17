class DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions = Devise::Mailer.confirmation_instructions(user, "faketoken")

  def reset_password_instructions = Devise::Mailer.reset_password_instructions(user, "faketoken")

  def unlock_instructions = Devise::Mailer.unlock_instructions(user, "faketoken")

  def email_changed = Devise::Mailer.email_changed(user)

  def password_change = Devise::Mailer.password_change(user)

  private

  def user = User.first
end
