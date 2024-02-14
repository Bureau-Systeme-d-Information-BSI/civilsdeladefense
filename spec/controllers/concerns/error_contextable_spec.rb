# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController do
  controller do
    include ErrorContextable

    def index
      render plain: "Hello World"
    end
  end

  describe "before_action" do
    context "when a user is authenticated" do
      let(:user) { create(:confirmed_user) }

      before do
        sign_in user
        allow(RorVsWild).to receive(:merge_error_context).with(email: user.email, id: user.id, ip_address: "0.0.0.0")
        get :index
      end

      it {
        expect(RorVsWild).to have_received(:merge_error_context).with(
          email: user.email,
          id: user.id,
          ip_address: "0.0.0.0"
        )
      }
    end

    context "when an administrator is authenticated" do
      let(:admin) { create(:administrator) }

      before do
        sign_in admin
        allow(RorVsWild).to receive(:merge_error_context).with(email: admin.email, id: admin.id, ip_address: "0.0.0.0")
        get :index
      end

      it {
        expect(RorVsWild).to have_received(:merge_error_context).with(
          email: admin.email,
          id: admin.id,
          ip_address: "0.0.0.0"
        )
      }
    end

    context "when no user nor administrator is authenticated" do
      before do
        allow(RorVsWild).to receive(:merge_error_context).with(email: nil, id: nil, ip_address: "0.0.0.0")
        get :index
      end

      it {
        expect(RorVsWild).to have_received(:merge_error_context).with(
          email: nil,
          id: nil,
          ip_address: "0.0.0.0"
        )
      }
    end
  end
end
