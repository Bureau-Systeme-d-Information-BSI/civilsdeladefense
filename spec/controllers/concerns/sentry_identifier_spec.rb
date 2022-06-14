# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    include SentryIdentifier

    def index
      render plain: "Hello World"
    end
  end

  describe "before_action" do
    context "when a user is authenticated" do
      let(:user) { create(:confirmed_user) }
      before { sign_in user }

      it "identifies to sentry using the user" do
        expect(Sentry).to receive(:set_user).with(email: user.email, id: user.id, ip_address: "0.0.0.0")
        get :index
      end
    end

    context "when an administrator is authenticated" do
      let(:admin) { create(:administrator) }
      before { sign_in admin }

      it "identifies to sentry using the admin" do
        expect(Sentry).to receive(:set_user).with(email: admin.email, id: admin.id, ip_address: "0.0.0.0")
        get :index
      end
    end

    context "when no user nor administrator is authenticated" do
      it "identifies to sentry using only the request ip" do
        expect(Sentry).to receive(:set_user).with(email: nil, id: nil, ip_address: "0.0.0.0")
        get :index
      end
    end
  end
end
