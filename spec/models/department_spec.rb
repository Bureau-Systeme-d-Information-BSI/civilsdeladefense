require "rails_helper"

RSpec.describe Department do
  describe "#label" do
    subject { department.label }

    context "when department is the None department" do
      let(:department) { build(:department, :none) }

      it { is_expected.to eq("Aucun") }
    end

    context "when department is not the None department" do
      let(:department) { build(:department) }

      it { is_expected.to eq("#{department.code} #{department.name} - #{department.name_region}") }
    end
  end

  describe "#short_label" do
    subject { department.short_label }

    context "when department is the None department" do
      let(:department) { build(:department, :none) }

      it { is_expected.to eq("Aucun") }
    end

    context "when department is not the None department" do
      let(:department) { build(:department) }

      it { is_expected.to eq("#{department.code} #{department.name}") }
    end
  end

  describe ".none" do
    subject(:none) { described_class.none }

    context "when the None department exists" do
      let!(:department) { create(:department, :none) }

      it { is_expected.to eq(department) }
    end

    context "when the None department does not exist" do
      it { expect { none }.to change(described_class, :count).by(1) }

      it { is_expected.to have_attributes(code: "00", name: "Aucun") }
    end
  end
end

# == Schema Information
#
# Table name: departments
#
#  id          :uuid             not null, primary key
#  code        :string
#  code_region :string
#  name        :string
#  name_region :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
