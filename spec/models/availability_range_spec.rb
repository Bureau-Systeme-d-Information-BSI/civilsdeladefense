# frozen_string_literal: true

require "rails_helper"

RSpec.describe AvailabilityRange do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }

    describe "#check_employed on update" do
      subject(:update_availability_range) { availability_range.update(name: "something else") }

      let(:availability_range) { create(:availability_range, name:) }

      before { update_availability_range }

      context "when the availability range is 'En poste'" do
        let(:name) { "En poste" }

        it { expect(availability_range).not_to be_valid }

        it "adds an error" do
          availability_range.valid?
          expect(availability_range.errors[:base]).to include("En poste ne peut pas être modifié")
        end
      end

      context "when the availability range is not 'En poste'" do
        let(:name) { "A name" }

        it { expect(availability_range).to be_valid }
      end
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:profiles).dependent(:nullify) }
  end

  describe "before_destroy callbacks" do
    it "does not allow deletion of 'En poste' availability ranges" do
      availability_range = create(:availability_range, name: "En poste")
      expect { availability_range.destroy! }.to raise_error(ActiveRecord::RecordNotDestroyed)
    end
  end

  describe "#employed" do
    subject(:employed) { described_class.employed }

    context "when the availability range exists" do
      let!(:availability_range) { create(:availability_range, name: "En poste") }

      it { expect(employed).to eq(availability_range) }
    end

    context "when the availability range does not exist" do
      it { expect(employed).to be_nil }
    end
  end

  describe "#employed?" do
    let(:availability_range) { create(:availability_range, name:) }

    context "when the availability range is 'En poste'" do
      let(:name) { "En poste" }

      it { expect(availability_range).to be_employed }
    end

    context "when the availability range is not 'En poste'" do
      let(:name) { "A name" }

      it { expect(availability_range).not_to be_employed }
    end
  end
end

# == Schema Information
#
# Table name: availability_ranges
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_availability_ranges_on_name      (name) UNIQUE
#  index_availability_ranges_on_position  (position)
#
