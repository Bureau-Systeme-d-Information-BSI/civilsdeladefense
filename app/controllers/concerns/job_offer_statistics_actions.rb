# frozen_string_literal: true

# Job offer state actions metaprogrammed from the array of state names
module JobOfferStatisticsActions
  extend ActiveSupport::Concern

  # GET /admin/job_offers/1/stats
  # GET /admin/job_offers/1/stats.json
  def stats
    date_end = Date.parse(params[:end]) if params[:end].present?
    date_end ||= Date.today
    date_start = Date.parse(params[:start]) if params[:start].present?
    date_start ||= date_end - 7.days

    @date_start_display = date_start.to_date.strftime('%d/%m/%Y')
    @date_end_display = date_end.to_date.strftime('%d/%m/%Y')

    @per_day = @job_offer.job_applications.unscope(:order)
                         .group_by_day(:created_at, range: date_start..date_end).count
    stats_relationship = @job_offer.job_applications.joins(:personal_profile).unscope(:order)
                                   .where(job_applications: { created_at: date_start..date_end })
    @per_gender = stats_relationship.group(:gender).count
    @per_nationality = stats_relationship.group(:nationality).count
  end
end
