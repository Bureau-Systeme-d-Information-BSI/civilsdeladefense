# frozen_string_literal: true

# Mail sent to administrator when account is deactivate
class DeactivationMailer < ApplicationMailer
  def period_before(administrator)
    @administrator = administrator
    @service_name = administrator.organization.service_name
    @days_notice_period_before_deletion = ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DEACTIVATION"].to_i

    to = @administrator.email
    subject = "[#{@service_name}] Votre compte utilisateur : mise à jour nécessaire"

    mail to: to, subject: subject
  end

  def notice(administrator)
    @full_name = administrator.full_name
    @service_name = administrator.organization.service_name

    to = administrator.email
    subject = "[#{@service_name}] Votre compte utilisateur a été désactivé"

    mail to: to, subject: subject
  end
end
