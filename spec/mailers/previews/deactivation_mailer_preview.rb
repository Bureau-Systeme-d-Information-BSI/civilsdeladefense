class DeactivationMailerPreview < ActionMailer::Preview
  def period_before = DeactivationMailer.period_before(Administrator.first)

  def notice = DeactivationMailer.notice(Administrator.first)
end
