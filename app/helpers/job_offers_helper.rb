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
      salary: "money-euro-box-line"
    }[attribute]
  end

  def job_offer_value_for_attribute(job_offer, attribute)
    case attribute
    when :contract_type
      job_offer_contract_type_display(job_offer)
    when :contract_start_on
      job_offer_start_display(job_offer)
    when :location
      job_offer.location
    when :study_level, :category, :experience_level
      job_offer.send(attribute).name
    when :salary
      job_offer_salary_display(job_offer)
    end
  end

  def job_offer_contract_type_display(job_offer)
    [job_offer.contract_type.name, job_offer.duration_contract].join(" ")
  end

  def job_offer_start_display(job_offer)
    if job_offer.available_immediately?
      t(".available_immediately")
    else
      I18n.l(job_offer.contract_start_on)
    end
  end

  def job_offer_salary_display(job_offer)
    res = []
    res << "#{job_offer.estimate_monthly_salary_net} mensuel net"
    res << "#{job_offer.estimate_annual_salary_gross} annuel brut (selon expérience)"
    res << "#{t(".benefit")} : #{job_offer.benefit.name}" if job_offer.benefit.present?
    res.join("<br/>").html_safe
  end
end
