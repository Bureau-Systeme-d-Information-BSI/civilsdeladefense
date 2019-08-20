# frozen_string_literal: true

# Job offer state actions metaprogrammed from the array of state names
module JobOfferStatisticsActions
  extend ActiveSupport::Concern

  # GET /admin/job_offers/1/stats
  # GET /admin/job_offers/1/stats.json
  def stats
    @job_applications_count = @job_offer.job_applications.count
    @per_day = @job_offer.job_applications.unscope(:order)
                         .group_by_day(:created_at, range: date_start..date_end).count

    @per_day.transform_keys! { |key| key.to_time.iso8601 }

    root_rel = @job_offer.job_applications
                         .unscope(:order)
    root_rel_profile = root_rel.joins(:personal_profile)

    @per_gender = root_rel_profile.group(:gender).count
    @per_nationality = root_rel_profile.group(:nationality).count
    @per_experiences_fit_job_offer = root_rel.group(:experiences_fit_job_offer).count
    @per_has_corporate_experience = root_rel_profile.group(:has_corporate_experience).count
    @per_is_currently_employed = root_rel_profile.group(:is_currently_employed).count
    @per_state = root_rel.group(:state).count
    @per_rejection_reason = root_rel.group(:rejection_reason_id).count
    @rejection_reasons = RejectionReason.all
  end

  def date_start
    @date_start ||= begin
      res = Date.parse(params[:start]) if params[:start].present?
      res || @job_offer.published_at&.to_date
    end
  end

  def date_end
    @date_end ||= begin
      res = Date.parse(params[:end]) if params[:end].present?
      res ||= @job_offer.archived_at&.to_date
      res || Date.today.to_time.to_date
    end
  end
end
