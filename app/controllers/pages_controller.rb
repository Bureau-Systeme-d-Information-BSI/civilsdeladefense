# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :find_page

  def show
    render layout: "cms"
  end

  protected

  def find_page
    @page = Page.friendly.find params[:id]

    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the page_path, and we should do
    # a 301 redirect that uses the current friendly id.
    return unless request.path != page_path(@page)

    redirect_to @page, status: :moved_permanently
  end
end
