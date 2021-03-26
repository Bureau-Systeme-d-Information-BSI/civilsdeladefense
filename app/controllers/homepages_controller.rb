# frozen_string_literal: true

class HomepagesController < ApplicationController
  # GET /
  def show
    @page = current_organization.pages.where(parent_id: nil).first
    root_rel = current_organization.job_offers
      .publicly_visible
      .includes(:contract_type)
      .order(published_at: :desc)
    @job_offers_selected = root_rel.last(3)
    @job_offers_last = root_rel.last(6)

    @page = current_organization.pages.where(parent_id: nil).first
    @categories = Category.order("lft ASC").where(
      "published_job_offers_count > ? AND depth <= ?", 0, 1
    )

    @contract_types = ContractType.all
  end
end
