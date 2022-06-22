namespace :migrate_data do
  task rebuild_job_offer_timestamp: :environment do
    JobOffer.states.each do |state_name, _|
      at_attr = "#{state_name}_at"
      next unless JobOffer.new.respond_to?(at_attr)

      enum_state = JobOffer.states[state_name]
      job_offers = JobOffer.where(at_attr => nil)

      Rails.logger.info("Migration start for #{state_name} : #{job_offers.count} job offers without date")
      res = 0

      job_offers.each do |job_offer|
        target_audit = job_offer.audits.reorder(version: :desc).detect { |audit|
          state_val = audit.audited_changes["state"]
          case state_val
          when nil
            false
          when Array
            state_val.last == enum_state
          when String
            state_val == enum_state
          end
        }

        if target_audit
          res += 1
          job_offer.update_column(at_attr, target_audit.created_at) # rubocop:disable Rails/SkipsModelValidations
        end
      end

      Rails.logger.info("#{res} job offers has been set")
    end
  end
end
