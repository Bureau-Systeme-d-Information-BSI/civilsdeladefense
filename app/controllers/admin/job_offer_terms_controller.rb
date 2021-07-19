# frozen_string_literal: true

class Admin::JobOfferTermsController < Admin::BaseController
  def index
    @job_offer_terms = JobOfferTerm.all
  end
end
