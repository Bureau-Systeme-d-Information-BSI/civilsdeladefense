namespace :maintenance do
  task draft_invalid_job_offer: :environment do
    describe "Move published offer that are invalid to draft state and return list of slug"
    result = []
    JobOffer.publicly_visible.map do |job_offer|
      next if job_offer.valid?

      job_offer.update_column(:state, :draft) # rubocop:disable Rails/SkipsModelValidations
      result << job_offer
    end

    slugs = result.pluck(:slug).join("\n")
    Rails.logger.info("Draft #{result.count} job offers :\n#{slugs}")
  end
end
