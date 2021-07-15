# frozen_string_literal: true

class Admin::Stats::JobOffersController < Admin::Stats::BaseController
  before_action :filter_by_full_text, only: %i[index], if: -> { permitted_params[:s].present? }
  before_action :fetch_base_ressources, only: %i[index]

  # GET /admin/stats/candidatures
  # GET /admin/stats/candidatures.json
  def index
    @job_offers = @job_offers.where(created_at: date_range)
    @q = @job_offers.ransack(permitted_params[:q])
    @job_offers_filtered = @q.result(distinct: true)
    @job_offers_count = @job_offers_filtered.count
    @job_offer_published = @job_offers_filtered.where(state: :published)
    @job_offer_unfilled = @job_offers_filtered.where.not(
      most_advanced_job_applications_state: JobApplication::FILLED_STATES
    )
    @job_offer_filled = @job_offers_filtered.where(
      most_advanced_job_applications_state: JobApplication::FILLED_STATES
    )
    @permitted_params = permitted_params

    @profiles = Profile.joins(job_application: :job_offer).where(job_applications: {job_offers: @job_offers})
    @profile_availables = @profiles.where.not(availability_range: AvailabilityRange.en_poste)

    @per_day = root_rel.group_by_day(:created_at, range: date_range).count
    build_average_affection

    respond_to do |format|
      format.html {}
      format.js {}
      format.xlsx {
        file = Exporter::StatJobOffers.new(export_data, current_administrator).generate
        send_data file.read, filename: "#{Time.zone.today}_e-recrutement_stats_offres.xlsx"
      }
    end
  end

  protected

  def root_rel
    @root_rel ||= @q.result(distinct: true).unscope(:order)
  end

  def filter_by_full_text
    @job_offers = @job_offers.search_full_text(permitted_params[:s]).unscope(:order)
  end

  def build_average_affection
    from_state = JobOffer.states["published"].to_s
    to_state = JobOffer.most_advanced_job_applications_states["affected"].to_s
    days = root_rel
      .joins('INNER JOIN "audits" AS audits_start ON "audits_start"."auditable_type" = \'JobOffer\' AND "audits_start"."auditable_id" = "job_offers"."id"')
      .joins('INNER JOIN "audits" AS audits_end ON "audits_start"."auditable_type" = \'JobOffer\'
        AND "audits_end"."auditable_id" = "job_offers"."id"')
      .where("audits_start.audited_changes->?->-1 @> ?", :state, from_state)
      .where("audits_end.audited_changes->?->-1 @> ?", :most_advanced_job_applications_state, to_state)
      .pluck(Arel.sql("DATE_PART('day', audits_end.created_at - audits_start.created_at)"))

    @average_affection = days.present? ? (days.reduce(:+) / days.size.to_f).round : "-"
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
        employer_id_in: [], job_offer_category_id_in: [], county_in: [],
        contract_type_id_in: [], job_offer_bop_id_in: []
      }
    )
  end

  def export_data
    {
      job_offers_count: @job_offers_count,
      date_start: @date_start,
      date_end: @date_end,
      job_offer_published: @job_offer_published.count,
      job_offer_unfilled: @job_offer_unfilled.count,
      job_offer_filled: @job_offer_filled.count,
      profiles: @profiles.count,
      profile_availables: @profile_availables.count,
      average_affection: @average_affection,
      q: permitted_params[:q] || {}
    }
  end
end
