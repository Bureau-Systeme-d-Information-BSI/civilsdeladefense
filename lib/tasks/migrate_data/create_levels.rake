namespace :migrate_data do
  task migrate_job_offers: :environment do
    scope = JobOffer.unscoped.where(level_id: nil)
    Rails.logger.info("Migration start : #{scope.count} job offers without level")

    level = Level.first
    scope.find_each do |job_offer|
      Rails.logger.info("Migration : #{job_offer.id} job offer without level")
      job_offer.update_columns(level_id: level.id) # rubocop:disable Rails/SkipsModelValidations
    end

    Rails.logger.info("Migration end")
  end
end
