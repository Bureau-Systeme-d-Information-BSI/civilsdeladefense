# frozen_string_literal: true

class Admin::JobOffers::ActorsController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :authorize_add_actor
  before_action :set_job_offer

  def new
    @administrator = find_administrator_and_build_job_offer_actor(@job_offer, params[:email].downcase, params[:role])
    if @administrator.present?
      render :new, layout: false
    else
      render :new_error, status: :unprocessable_content
    end
  end

  private

  def authorize_add_actor
    authorize! :add_actor, JobOffer
  end

  def set_job_offer
    @job_offer = params[:job_offer_id].present? ? JobOffer.find(params[:job_offer_id]) : JobOffer.new
  end

  def find_administrator_and_build_job_offer_actor(job_offer, email, role)
    return nil if email.blank?

    administrator = Administrator.find_by(email:)
    return nil if administrator.nil?

    job_offer_actor = job_offer.job_offer_actors.build(role:)
    job_offer_actor.administrator = administrator
    administrator
  end
end
