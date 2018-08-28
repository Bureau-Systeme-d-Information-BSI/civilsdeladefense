class SitemapsController < ApplicationController

  def show
    @job_offers = JobOffer.publicly_visible.all
  end
end
