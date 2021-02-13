# frozen_string_literal: true

module NamingHelper
  def tos_acceptance_text
    opts = {
      link: current_organization.privacy_policy_url,
      service_name: current_organization.service_name,
      legal_name: current_organization.legal_name
    }
    label = t('simple_form.labels.user.terms_of_service', opts).html_safe
    content_tag('span', label, style: 'display: inline;')
  end

  def footer_social_intro
    possessive_article = current_organization.possessive_article
    name = current_organization.operator_name if current_organization.operator_name.present?
    name ||= current_organization.brand_name
    "Les réseaux sociaux #{possessive_article}#{strip_tags(name)}"
  end

  def copyright
    legal_name = current_organization.legal_name
    "© #{legal_name} #{Time.now.year}"
  end
end
