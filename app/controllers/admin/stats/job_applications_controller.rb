# frozen_string_literal: true

class Admin::Stats::JobApplicationsController < Admin::Stats::BaseController
  before_action :filter_by_full_text, only: %i[index], if: -> { permitted_params[:s].present? }
  before_action :fetch_base_ressources, only: %i[index]

  # GET /admin/stats/candidatures
  # GET /admin/stats/candidatures.json
  def index
    @job_applications = @job_applications.where(created_at: date_range)
    @q = @job_applications.ransack(permitted_params[:q])
    @job_applications_filtered = @q.result(distinct: true)
    @job_applications_count = @job_applications_filtered.count
    @permitted_params = permitted_params
    build_stats
    build_stats_per_profile
    build_state_duration

    respond_to do |format|
      format.html {}
      format.js {}
      format.xlsx {
        file = Exporter::StatJobApplications.new(export_data, current_administrator).generate
        send_data file.read, filename: "#{Time.zone.today}_e-recrutement_stats_candidatures.xlsx"
      }
    end
  end

  protected

  def root_rel
    @root_rel ||= @q.result(distinct: true).unscope(:order)
  end

  def root_rel_profile
    @root_rel_profile ||= root_rel.joins(:profile)
  end

  def build_stats
    @per_day = root_rel.group_by_day(:created_at, range: date_range).count
    @per_experiences_fit_job_offer = root_rel.group(:experiences_fit_job_offer).count
    @per_rejection_reason = root_rel.where.not(rejection_reason_id: nil)
      .group(:rejection_reason_id).count
    @per_state = root_rel.group(:state).count
    @in_department_count = root_rel.joins(:job_offer, user: :departments).where(
      "departments.code = job_offers.county_code::text"
    ).count
  end

  def build_stats_per_profile
    @per_gender = root_rel_profile.group(:gender).count
    @per_age_range = root_rel_profile.group(:age_range_id).count
    @per_has_corporate_experience = root_rel_profile.group(:has_corporate_experience).count
    @per_is_currently_employed = root_rel_profile.group(:is_currently_employed).count
  end

  def filter_by_full_text
    @job_applications = @job_applications.search_full_text(permitted_params[:s]).unscope(:order)
  end

  STATE_DURATION = [
    [:initial, :rejected],
    [:initial, :phone_meeting],
    [:phone_meeting, :phone_meeting_rejected],
    [:phone_meeting, :to_be_met],
    [:to_be_met, :after_meeting_rejected],
    [:to_be_met, :accepted],
    [:accepted, :contract_drafting],
    [:contract_drafting, :contract_feedback_waiting],
    [:contract_feedback_waiting, :contract_received],
    [:contract_received, :affected]
  ]
  def build_state_duration
    @state_duration ||= STATE_DURATION.map { |from, to|
      from_state = JobApplication.states[from].to_s
      to_state = JobApplication.states[to].to_s
      days = root_rel
        .joins('INNER JOIN "audits" AS audits_start ON "audits_start"."auditable_type" = \'JobApplication\' AND "audits_start"."auditable_id" = "job_applications"."id"')
        .joins('INNER JOIN "audits" AS audits_end ON "audits_start"."auditable_type" = \'JobApplication\'
          AND "audits_end"."auditable_id" = "job_applications"."id"')
        .where("audits_start.audited_changes->?->-1 @> ?", :state, from_state)
        .where("audits_end.audited_changes->?->-1 @> ?", :state, to_state)
        .pluck(Arel.sql("DATE_PART('day', audits_end.created_at - audits_start.created_at)"))
      average = days.present? ? (days.reduce(:+) / days.size.to_f).round : "-"
      [from, to, average]
    }
  end

  def date_start
    @date_start ||= begin
      res = Date.parse(permitted_params[:start]) if permitted_params[:start].present?
      res ||= 30.days.ago.beginning_of_day
      res
    end
  end

  def date_end
    @date_end ||= begin
      res = Date.parse(permitted_params[:end]) if permitted_params[:end].present?
      res ||= Time.current
      res
    end
  end

  def date_range
    date_start..date_end if date_start.present? && date_end.present?
  end

  def fetch_base_ressources
    @bops = Bop.all
    @contract_types = ContractType.all
    @employers = Employer.tree
    @rejection_reasons = RejectionReason.all
    @age_ranges = AgeRange.all
  end

  def permitted_params
    params.permit(
      :s, :start, :end,
      q: {
        employer_id_in: [], job_offer_category_id_in: [],
        contract_type_id_in: [], job_offer_bop_id_in: []
      }
    )
  end

  def export_data
    {
      job_applications_count: @job_applications_count,
      date_start: @date_start,
      date_end: @date_end,
      state_duration: @state_duration,
      per_state: @per_state,
      per_experiences_fit_job_offer: @per_experiences_fit_job_offer,
      per_has_corporate_experience: @per_has_corporate_experience,
      per_is_currently_employed: @per_is_currently_employed,
      per_rejection_reason: @per_rejection_reason,
      per_gender: @per_gender,
      per_age_range: @per_age_range,
      rejection_reasons: @rejection_reasons,
      age_ranges: @age_ranges,
      q: permitted_params[:q] || {}
    }
  end
end
