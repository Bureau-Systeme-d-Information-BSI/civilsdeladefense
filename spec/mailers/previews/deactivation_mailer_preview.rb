class DeactivationMailerPreview < ActionMailer::Preview
  def period_before
    DeactivationMailer.period_before(Administrator.first)
  end
end
