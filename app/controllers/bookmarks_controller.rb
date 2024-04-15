class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job_offer

  def create = current_user.bookmarks.create!(job_offer: @job_offer)

  def destroy = current_user.bookmarks.find_by!(job_offer: @job_offer).destroy!

  private

  def set_job_offer = @job_offer = JobOffer.find(params[:id])
end
