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
                         .where(job_applications: { created_at: date_start..date_end })
    root_rel_profile = root_rel.joins(:personal_profile)

    @per_gender = root_rel_profile.group(:gender).count
    @per_nationality = root_rel_profile.group(:nationality).count
    @experiences_fit_job_offer_count = root_rel.where(experiences_fit_job_offer: true).count
    opts = { personal_profiles: { has_corporate_experience: true }}
    @has_corporate_experience_count = root_rel_profile.where(opts).count
    opts = { personal_profiles: { is_currently_employed: true }}
    @is_currently_employed_count = root_rel_profile.where(opts).count
    @per_state = root_rel.group(:state).count
    @per_rejection_reason = root_rel.group(:rejection_reason_id).count
    @rejection_reasons = RejectionReason.all
  end

  def date_start
    @date_start ||= begin
      res = Date.parse(params[:start]) if params[:start].present?
      res || @job_offer.published_at.to_date
    end
  end

  def date_end
    @date_end ||= begin
      res = Date.parse(params[:end]) if params[:end].present?
      res || Date.today.to_time.to_date
    end
  end
end
