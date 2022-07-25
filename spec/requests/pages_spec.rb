# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /pages/:id" do
    it "renders the template" do
      get page_path(create(:page))
      expect(response).to render_template(:show)
    end
  end
end
