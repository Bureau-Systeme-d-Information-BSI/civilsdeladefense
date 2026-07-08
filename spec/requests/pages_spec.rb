# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pages" do
  describe "GET /pages/:id" do
    it "renders the template" do
      get page_path(create(:page))
      expect(response).to render_template(:show)
    end
  end

  describe "GET /pages/:id with a non-canonical id" do
    subject(:show_by_id) { get page_path(page.id) }

    let(:page) { create(:page) }

    before { show_by_id }

    it { expect(response).to redirect_to(page_path(page)) }
  end
end
