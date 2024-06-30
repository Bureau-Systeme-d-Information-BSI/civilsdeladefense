namespace :migrate_data do
  task create_levels: :environment do
    ["A", "B", "C", "1", "2", "3"].each do |name|
      Level.find_by(name: name) || Level.create!(name: name)
    end
  end

  task migrate_job_offers: :environment do
    scope = JobOffer.unscoped.where(level_id: nil)
    Rails.logger.info("Migration start : #{scope.count} job offers without level")

    level = Level.find_by!(name: "1")
    scope.find_each do |job_offer|
      Rails.logger.info("Migration : #{job_offer.id} job offer without level")
      job_offer.update!(level: level)
    end

    Rails.logger.info("Migration end")
  end
end
