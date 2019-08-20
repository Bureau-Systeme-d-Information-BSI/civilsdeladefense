# frozen_string_literal: true

class Admin::Stats::JobApplicationsController < Admin::Stats::BaseController
  # GET /admin/stats/candidatures
  # GET /admin/stats/candidatures.json
  def index
    range = date_start..date_end if date_start.present? && date_end.present?
    @employers = Employer.all
    if params[:s].present?
      @job_applications = @job_applications.search_full_text(params[:s])
                                           .unscope(:order)
    end
    @job_applications = @job_applications.where(created_at: range)
    @q = @job_applications.ransack(params[:q])
    @job_applications_filtered = @q.result(distinct: true)
                                   .page(params[:page])
                                   .per_page(20)
    @job_applications_count = @job_applications_filtered.count
    @per_day = @q.result(distinct: true)
                 .unscope(:order)
                 .group_by_day(:created_at, range: range)
                 .count
    @per_gender = @q.result(distinct: true)
                    .unscope(:order)
                    .joins(:personal_profile)
                    .group(:gender)
                    .count
    @per_nationality = @q.result(distinct: true)
                         .unscope(:order)
                         .joins(:personal_profile)
                         .group(:nationality)
                         .count

    @per_experiences_fit_job_offer = @q.result(distinct: true)
                                       .unscope(:order)
                                       .group(:experiences_fit_job_offer)
                                       .count
    @per_has_corporate_experience = @q.result(distinct: true)
                                      .unscope(:order)
                                      .joins(:personal_profile)
                                      .group(:has_corporate_experience)
                                      .count
    @per_is_currently_employed = @q.result(distinct: true)
                                   .unscope(:order)
                                   .joins(:personal_profile)
                                   .group(:is_currently_employed)
                                   .count
    @per_rejection_reason = @q.result(distinct: true)
                              .unscope(:order)
                              .group(:rejection_reason_id)
                              .count
    @per_state = @q.result(distinct: true)
                   .unscope(:order)
                   .group(:state)
                   .count
    @rejection_reasons = RejectionReason.all
  end

  protected

  def date_start
    @date_start ||= begin
      res = Date.parse(params[:start]) if params[:start].present?
      res || 30.days.ago.beginning_of_day
    end
  end

  def date_end
    @date_end ||= begin
      res = Date.parse(params[:end]) if params[:end].present?
      res || Time.current
    end
  end
end
