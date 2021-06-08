# frozen_string_literal: true

class Admin::Stats::JobOffersController < Admin::Stats::BaseController
  before_action :filter_by_full_text, only: %i[index], if: -> { params[:s].present? }
  before_action :fetch_base_ressources, only: %i[index]

  # GET /admin/stats/candidatures
  # GET /admin/stats/candidatures.json
  def index
    @job_offers = @job_offers.where(created_at: date_range)
    @q = @job_offers.ransack(params[:q])
    @job_offers_filtered = @q.result(distinct: true)
      .page(params[:page])
      .per_page(20)
    @job_offers_count = @job_offers_filtered.count
    build_state_duration
    build_employer_ids unless current_administrator.bant?
  end

  protected

  def root_rel
    @root_rel ||= @q.result(distinct: true).unscope(:order)
  end

  def filter_by_full_text
    @job_offers = @job_offers.search_full_text(params[:s]).unscope(:order)
  end

  def build_state_duration
    return @state_duration if @state_duration.present?
    from = "published"
    to = "affected"
    from_state = JobOffer.states[from].to_s
    to_state = JobOffer.most_advanced_job_applications_states[to].to_s
    days = root_rel
      .joins('INNER JOIN "audits" AS audits_start ON "audits_start"."auditable_type" = \'JobOffer\' AND "audits_start"."auditable_id" = "job_offers"."id"')
      .joins('INNER JOIN "audits" AS audits_end ON "audits_start"."auditable_type" = \'JobOffer\'
        AND "audits_end"."auditable_id" = "job_offers"."id"')
      .where("audits_start.audited_changes->?->-1 @> ?", :state, from_state)
      .where("audits_end.audited_changes->?->-1 @> ?", :most_advanced_job_applications_state, to_state)
      .pluck(Arel.sql("DATE_PART('day', audits_end.created_at - audits_start.created_at)"))
    average = days.present? ? (days.reduce(:+) / days.size.to_f).round : "-"
    @state_duration = {
      from: from, to: to, average: average
    }
  end

  def build_employer_ids
    @employer_ids = @job_offers.pluck(:employer_id).uniq
  end

  def date_start
    @date_start ||= begin
      res = Date.parse(params[:start]) if params[:start].present?
      res ||= 30.days.ago.beginning_of_day
      res
    end
  end

  def date_end
    @date_end ||= begin
      res = Date.parse(params[:end]) if params[:end].present?
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
    @employers = Employer.all
    @rejection_reasons = RejectionReason.all
    @age_ranges = AgeRange.all
  end
end
