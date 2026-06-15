# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Pages" do
  before { sign_in create(:administrator) }

  let(:organization) { Organization.first }

  it_behaves_like "an admin setting", :page, :og_title, "a new title"

  describe "PATCH /admin/parametres/pages/:id" do
    subject(:update_request) { patch admin_settings_page_path(page), params: {page: {title: "New title"}} }

    let(:page) { Page.create!(organization:, title: "Title", slug: "title") }

    it { expect { update_request }.to change { page.reload.slug }.to("new-title") }
  end

  describe "DELETE /admin/parametres/pages/:id" do
    subject(:destroy_request) { delete admin_settings_page_path(parent) }

    let(:grandparent) { Page.create!(organization:, title: "Grandparent") }
    let(:parent) { Page.create!(organization:, title: "Parent", parent: grandparent) }
    let(:child) { Page.create!(organization:, title: "Child", parent:) }

    before { child }

    context "when the page has dependent children" do
      it { expect { destroy_request }.to change { Page.exists?(parent.id) }.to(false) }

      it { expect { destroy_request }.to change { child.reload.parent_id }.from(parent.id).to(grandparent.id) }
    end
  end

  describe "POST /admin/parametres/pages/:id/move_higher" do
    subject(:move_higher_request) { post move_higher_admin_settings_page_path(second) }

    let(:root) { Page.create!(organization:, title: "Root") }
    let(:first) { Page.create!(organization:, title: "First", parent: root) }
    let(:second) { Page.create!(organization:, title: "Second", parent: root) }

    before { [first, second] }

    it { expect(move_higher_request).to redirect_to(admin_settings_pages_path) }

    it { expect { move_higher_request }.to change { sibling_titles(root) }.to(%w[Second First]) }
  end

  describe "POST /admin/parametres/pages/:id/move_lower" do
    subject(:move_lower_request) { post move_lower_admin_settings_page_path(first) }

    let(:root) { Page.create!(organization:, title: "Root") }
    let(:first) { Page.create!(organization:, title: "First", parent: root) }
    let(:second) { Page.create!(organization:, title: "Second", parent: root) }

    before { [first, second] }

    it { expect(move_lower_request).to redirect_to(admin_settings_pages_path) }

    it { expect { move_lower_request }.to change { sibling_titles(root) }.to(%w[Second First]) }
  end

  private

  def sibling_titles(root)
    root.reload.children.order(:lft).pluck(:title)
  end
end
