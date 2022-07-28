# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Organizations", type: :request do
  let(:organization) { Organization.first }

  before { sign_in create(:administrator) }

  describe "GET /admin/parametres/organization/edit" do
    it "renders the template" do
      expect(get(edit_admin_settings_organization_path)).to render_template(:edit)
    end
  end

  describe "PATCH /admin/parametres/organization" do
    subject(:update_request) { patch admin_settings_organization_path, params: params }

    context "when organization is valid" do
      let(:new_brand_name) { "new brand name" }
      let(:params) {
        {
          organization: {
            brand_name: new_brand_name
          }
        }
      }

      it "updates the organization" do
        expect { update_request }.to change { organization.reload.brand_name }.to(new_brand_name)
      end

      it "redirects to edit" do
        expect(update_request).to redirect_to(edit_admin_settings_organization_path)
      end
    end

    context "when organization is invalid" do
      let(:params) {
        {
          organization: {
            brand_name: ""
          }
        }
      }

      it "doesn't update the organization" do
        expect { update_request }.not_to change { organization.reload.brand_name }
      end

      it "renders the edit template" do
        expect(update_request).to render_template(:edit)
      end
    end
  end

  describe "GET /admin/parametres/organization/edit_security" do
    it "renders the template" do
      expect(get(edit_security_admin_settings_organization_path)).to render_template(:edit_security)
    end
  end

  describe "PATCH /admin/parametres/organization/update_security" do
    subject(:update_request) {
      patch update_security_admin_settings_organization_path, params:  {
        organization: {
          administrator_email_suffix: new_administrator_email_suffix
        }
      }
    }

    let(:new_administrator_email_suffix) { "tric.com" }

    context "when organization is valid" do
      it "updates the organization" do
        expect {
          update_request
        }.to change { organization.reload.administrator_email_suffix }.to(new_administrator_email_suffix)
      end

      it "redirects to edit security" do
        expect(update_request).to redirect_to(edit_security_admin_settings_organization_path)
      end
    end

    context "when organization is invalid" do
      before { allow_any_instance_of(Organization).to receive(:update).and_return(false) }

      it "doesn't update the organization" do
        expect { update_request }.not_to change { organization.reload.administrator_email_suffix }
      end

      it "renders the edit template" do
        expect(update_request).to render_template(:edit)
      end
    end
  end
end
