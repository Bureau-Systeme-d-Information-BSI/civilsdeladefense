class PlatformMailerPreview < ActionMailer::Preview
  def confirmation_instructions = PlatformMailer.confirmation_instructions(Administrator.first, "faketoken")

  def reset_password_instructions = PlatformMailer.reset_password_instructions(Administrator.first, "faketoken")

  def unlock_instructions = PlatformMailer.unlock_instructions(Administrator.first, "faketoken")

  def email_changed = PlatformMailer.email_changed(Administrator.first)

  def password_change = PlatformMailer.password_change(Administrator.first)
end
