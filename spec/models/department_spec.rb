require "rails_helper"

RSpec.describe Department do
  describe "#label" do
    subject { department.label }

    context "when department is the None department" do
      let(:department) { build(:department, :none) }

      it { is_expected.to eq("None") }
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

      it { is_expected.to eq("None") }
    end

    context "when department is not the None department" do
      let(:department) { build(:department) }

      it { is_expected.to eq("#{department.code} #{department.name}") }
    end
  end

  describe ".none" do
    subject { described_class.none }

    let!(:department) { create(:department, code: "00") }

    it { is_expected.to eq(department) }
  end
end
