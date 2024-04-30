class PlatformMailerPreview < ActionMailer::Preview
  def confirmation_instructions_admin = PlatformMailer.confirmation_instructions(admin, "faketoken")

  def confirmation_instructions_user = PlatformMailer.confirmation_instructions(user, "faketoken")

  def reset_password_instructions = PlatformMailer.reset_password_instructions(admin, "faketoken")

  def unlock_instructions = PlatformMailer.unlock_instructions(admin, "faketoken")

  def email_changed = PlatformMailer.email_changed(admin)

  def password_change = PlatformMailer.password_change(admin)

  private

  def admin = Administrator.first

  def user = User.first
end
