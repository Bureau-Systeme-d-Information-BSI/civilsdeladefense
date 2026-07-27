# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ApplicationController" do
  describe "#layout_by_resource" do
    context "with a non-administrator devise controller" do
      subject(:perform) { get new_user_session_path }

      before { perform }

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
