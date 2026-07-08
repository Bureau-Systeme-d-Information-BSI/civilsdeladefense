# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Categories" do
  it_behaves_like "an admin setting", :category, :name, "a new name"
  it_behaves_like "a laterally movable admin setting", :category

  describe "Destroying a category" do
    subject(:destroy_request) { delete admin_settings_category_path(category) }

    before { sign_in create(:administrator) }

    let!(:category) { create(:category) }

    it { expect { destroy_request }.to change(Category, :count).by(-1) }

    context "when the category has job offers" do
      before { create(:job_offer, category: category) }

      it { expect { destroy_request }.to change(Category, :count).by(-1) }
    end

    context "when the category has job applications" do
      before { create(:job_application, category: category) }

      it { expect { destroy_request }.to change(Category, :count).by(-1) }
    end

    context "when the category cannot be destroyed" do
      before do
        allow_any_instance_of(Category).to receive(:children).and_return([])
        allow_any_instance_of(Category).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
      end

      it { expect(destroy_request).to redirect_to(admin_settings_categories_path) }

      it { expect { destroy_request }.not_to change(Category, :count) }
    end
  end
end
