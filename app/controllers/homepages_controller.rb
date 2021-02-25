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
    @job_offers_last = root_rel.last(9)

    @categories = Category.order("lft ASC").where("published_job_offers_count > ?", 0)
    @max_depth_limit = 1
    @categories_for_select = @categories.select { |x| x.depth <= @max_depth_limit }
    @contract_types = ContractType.all
  end
end
