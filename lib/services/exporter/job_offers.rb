class Exporter::JobOffers < Exporter::Base
  def fill_data
    add_row(
      "Référence",
      "Intitulé",
      "Employeur",
      "Secteur",
      "Type",
      "Durée",
      "Nombre de candidatures",
      "Statut",
      "Candidature la plus avancée",
      "Date de publication",
      "Lieu",
      "Catégorie",
      "Salaire NET",
      "Salaire BRUT",
      "Télétravail",
      "Option",
      "Acteurs"
    )
    data.map do |line|
      add_row(format_job_offer(line))
    end
  end

  def format_job_offer(job_offer)
    [
      job_offer.identifier,
      job_offer.title,
      job_offer.employer.name,
      job_offer.sector.name,
      job_offer.contract_type&.name&.presence || "",
      job_offer.contract_duration_name,
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
end
