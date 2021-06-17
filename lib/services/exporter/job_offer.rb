class Exporter::JobOffer < Exporter::Base
  def fill_data
    add_row(remove_html(data.description))
    add_row(remove_html(data.recruitment_process))
    add_row(remove_html(data.required_profile))
    add_row
    add_row(format_job_offer(data))
    add_row
    data.job_applications.each do |ja|
      add_row(format_job_application(ja))
    end
  end

  def format_job_offer(job_offer)
    [
      job_offer.identifier,
      job_offer.title,
      job_offer.employer.name,
      job_offer.sector.name,
      job_offer.contract_type.name,
      job_offer.duration_contract,
      job_offer.job_applications_count,
      JobOffer.human_attribute_name("state/#{job_offer.state}"),
      JobApplication.human_attribute_name("state/#{job_offer.most_advanced_job_applications_state}"),
      job_offer.published_at&.strftime("%d/%m/%Y %H:%M"),
      job_offer.location,
      job_offer.category.name,
      job_offer.estimate_monthly_salary_net,
      job_offer.estimate_annual_salary_gross,
      job_offer.is_remote_possible ? "Télétravail" : "",
      job_offer.benefit,
      format_actors(job_offer.job_offer_actors)
    ]
  end

  def format_job_application(job_application)
    user = job_application.user
    [
      user&.first_name,
      user&.last_name,
      user&.current_position,
      JobApplication.human_attribute_name("state/#{job_application.state}"),
      job_application.created_at
    ]
  end
end
