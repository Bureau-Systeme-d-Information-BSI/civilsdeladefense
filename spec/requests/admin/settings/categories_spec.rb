# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Categories" do
  it_behaves_like "an admin setting", :category, :name, "a new name"

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

  describe "POST /admin/parametres/categories/:id/move_left" do
    subject(:move_left_request) { post move_left_admin_settings_category_path(second) }

    before do
      sign_in create(:administrator)
      first
      second
    end

    let(:first) { create(:category, name: "First") }
    let(:second) { create(:category, name: "Second") }

    it { expect(move_left_request).to redirect_to(admin_settings_categories_path) }

    it { expect { move_left_request }.to change { category_names }.to(%w[Second First]) }
  end

  describe "POST /admin/parametres/categories/:id/move_right" do
    subject(:move_right_request) { post move_right_admin_settings_category_path(first) }

    before do
      sign_in create(:administrator)
      first
      second
    end

    let(:first) { create(:category, name: "First") }
    let(:second) { create(:category, name: "Second") }

    it { expect(move_right_request).to redirect_to(admin_settings_categories_path) }

    it { expect { move_right_request }.to change { category_names }.to(%w[Second First]) }
  end

  private

  def category_names
    Category.order(:lft).pluck(:name)
  end
end
