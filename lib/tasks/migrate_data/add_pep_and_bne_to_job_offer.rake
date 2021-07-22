namespace :migrate_data do
  task add_pep_and_bne_to_job_offer: :environment do
    job_offers = JobOffer.where(pep_value: nil, bne_value: nil, state: [:published, :suspended])

    Rails.logger.info("Migration start : set bne_value to `inconnue` and bne_date to `01/01/2020` for #{job_offers.count} job offers")

    result = job_offers.update_all(bne_value: "inconnue", bne_date: "01/01/2020")

    Rails.logger.info("#{result} job offers has been updated, list of ids -> #{job_offers.pluck(:id).join(" ")}")
  end
end
