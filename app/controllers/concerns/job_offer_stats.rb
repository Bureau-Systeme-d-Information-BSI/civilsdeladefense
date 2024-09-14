# frozen_string_literal: true

# Job offer state actions metaprogrammed from the array of state names
module JobOfferStats
  extend ActiveSupport::Concern

  # GET /admin/job_offers/1/stats
  # GET /admin/job_offers/1/stats.json
  def stats
    build_data
  end

  protected

  def date_start
    @job_offer.published_at&.to_date || @job_offer.created_at&.to_date
  end

  def date_end
    @job_offer.archived_at&.to_date || Time.current
  end

  def build_data
    @job_applications_count = @job_offer.job_applications.count
    @per_day = @job_offer.job_applications.unscope(:order).group_by_day(
      :created_at, range: date_start..date_end
    ).count.transform_keys { |key| key.to_time.iso8601 }

    root_rel = @job_offer.job_applications.unscope(:order)
    root_rel_profile = root_rel.joins(:profile)

    @per_gender = root_rel_profile.group("profiles.gender").count
    @per_age_range = root_rel_profile.group(:age_range_id).count
    @per_experiences_fit_job_offer = root_rel.group(:experiences_fit_job_offer).count
    @per_has_corporate_experience = root_rel_profile.group(:has_corporate_experience).count
    @per_is_currently_employed = root_rel_profile.group(:is_currently_employed).count
    @per_state = root_rel.group(:state).count
    @in_department_count = root_rel.joins(:job_offer, user: {profile: :departments}).where(
      "departments.code = job_offers.county_code::text"
    ).count
    @per_rejection_reason = root_rel.where.not(rejection_reason_id: nil).group(:rejection_reason_id).count
    @rejection_reasons = RejectionReason.all
    @age_ranges = AgeRange.all
  end

  def export_data
    build_data
    {
      job_applications_count: @job_applications_count,
      per_gender: @per_gender,
      per_age_range: @per_age_range,
      per_experiences_fit_job_offer: @per_experiences_fit_job_offer,
      per_has_corporate_experience: @per_has_corporate_experience,
      per_is_currently_employed: @per_is_currently_employed,
      per_state: @per_state,
      in_department_count: @in_department_count,
      per_rejection_reason: @per_rejection_reason,
      rejection_reasons: @rejection_reasons,
      age_ranges: @age_ranges
    }
  end
end
