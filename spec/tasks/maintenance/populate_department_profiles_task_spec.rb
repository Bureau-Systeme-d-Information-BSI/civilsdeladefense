# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateDepartmentProfilesTask do
    describe "#process" do
      subject(:process) { described_class.process(element) }
      let!(:element) { DepartmentUser.create!(user:, department:) }
      let!(:user) { create(:user) }
      let!(:department) { create(:department) }

      it { expect { process }.to change(DepartmentProfile, :count).by(1) }

      describe "created DepartmentProfile" do
        let(:department_profile) { process }

        it { expect(department_profile.profile).to eq(user.profile) }

        it { expect(department_profile.department).to eq(department) }
      end
    end
  end
end
