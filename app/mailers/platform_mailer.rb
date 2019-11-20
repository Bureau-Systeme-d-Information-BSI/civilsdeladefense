# frozen_string_literal: true

# Overwriting devise mailer class to allow site name injection in mail subjects
class PlatformMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def confirmation_instructions(record, token, opts = {})
    organization = record.organization
    site_name = organization.name
    i18n_key = 'devise.mailer.confirmation_instructions.subject'
    opts[:subject] = I18n.t(i18n_key, site_name: site_name)
    super
  end

  def reset_password_instructions(record, token, opts = {})
    organization = record.organization
    site_name = organization.name
    i18n_key = 'devise.mailer.reset_password_instructions.subject'
    opts[:subject] = I18n.t(i18n_key, site_name: site_name)
    super
  end

  def unlock_instructions(record, token, opts = {})
    organization = record.organization
    site_name = organization.name
    i18n_key = 'devise.mailer.unlock_instructions.subject'
    opts[:subject] = I18n.t(i18n_key, site_name: site_name)
    super
  end

  def email_changed(record, opts = {})
    organization = record.organization
    site_name = organization.name
    i18n_key = 'devise.mailer.email_changed.subject'
    opts[:subject] = I18n.t(i18n_key, site_name: site_name)
    super
  end

  def password_change(record, opts = {})
    organization = record.organization
    site_name = organization.name
    i18n_key = 'devise.mailer.password_change.subject'
    opts[:subject] = I18n.t(i18n_key, site_name: site_name)
    super
  end
end
