# frozen_string_literal: true

module JobOffersHelper
  def job_offer_icon_for_attribute(attribute)
    {
      contract_type: "briefcase-4-line",
      contract_start_on: "calendar-line",
      location: "map-pin-line",
      study_level: "focus-line",
      category: "building-line",
      experience_level: "focus-3-line",
      salary: "money-euro-box-line",
      benefits: "money-euro-box-line",
      is_remote_possible: "map-pin-line"
    }[attribute]
  end

  def job_offer_value_for_attribute(job_offer, attribute)
    case attribute
    when :contract_type
      job_offer_contract_type_display(job_offer)
    when :contract_start_on
      job_offer_start_display(job_offer)
    when :application_deadline
      job_offer_application_deadline_display(job_offer)
    when :location
      job_offer.location
    when :study_level, :category, :experience_level
      job_offer.send(attribute)&.name.presence || "-"
    when :salary
      job_offer_salary_display(job_offer)
    when :benefits
      job_offer_benefits_display(job_offer)
    when :drawbacks
      job_offer_drawbacks_display(job_offer)
    when :is_remote_possible
      job_offer_remote_display(job_offer)
    end
  end

  def job_offer_contract_type_display(job_offer)
    [job_offer.contract_type_name, job_offer.contract_duration_name].compact.join(" ")
  end

  def job_offer_start_display(job_offer) = I18n.l(job_offer.contract_start_on)

  def job_offer_application_deadline_display(job_offer)
    if job_offer.application_deadline.present?
      I18n.l(job_offer.application_deadline)
    else
      "-"
    end
  end

  def job_offer_salary_display(job_offer)
    res = []
    res << "#{job_offer.estimate_monthly_salary_net} mensuel net"
    res << "#{job_offer.estimate_annual_salary_gross} annuel brut (selon expérience)"
    res.join("<br/>").html_safe # rubocop:disable Rails/OutputSafety
  end

  def job_offer_benefits_display(job_offer)
    if job_offer.benefits.present?
      job_offer.benefits.pluck(:name).join("<br/>").html_safe # rubocop:disable Rails/OutputSafety
    else
      "-"
    end
  end

  def job_offer_drawbacks_display(job_offer)
    if job_offer.drawbacks.present?
      job_offer.drawbacks.pluck(:name).join("<br/>").html_safe # rubocop:disable Rails/OutputSafety
    else
      "-"
    end
  end

  def job_offer_remote_display(job_offer)
    if job_offer.is_remote_possible
      "Oui"
    else
      "Non"
    end
  end
end
