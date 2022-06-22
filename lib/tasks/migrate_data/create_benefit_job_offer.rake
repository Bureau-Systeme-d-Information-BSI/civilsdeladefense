namespace :migrate_data do
  task create_benefit_job_offer: :environment do
    job_offers = JobOffer.where.not(benefit_id: nil)

    Rails.logger.info("Migration start : move #{job_offers.count} job offers to new benefit model")

    errors = []

    job_offers.each do |job_offer|
      success = BenefitJobOffer.create(
        job_offer: job_offer, benefit_id: job_offer.benefit_id
      )
      success = job_offer.update_column(:benefit_id, nil) if success # rubocop:disable Rails/SkipsModelValidations
      errors << job_offer unless success
    end

    if errors.count > 1
      Rails.logger.error(
        "Migration end : #{errors.count} job offer didn't update -> #{errors.pluck(:id).join(" ")}"
      )
    else
      Rails.logger.info("Migration end : no error")
    end
  end
end
