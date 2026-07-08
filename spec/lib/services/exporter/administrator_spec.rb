# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exporter::Administrator do
  let(:admin) { create(:administrator) }
  let(:employer) { create(:employer) }
  let(:exported_admin) { create(:administrator, employer:) }
  let(:data) do
    {
      data: [exported_admin],
      q: {
        employer_id_eq: employer.id,
        first_name_or_last_name_or_email_cont: exported_admin.last_name,
        role_eq: "0"
      }
    }
  end

  before { create(:job_offer, owner: exported_admin) }

  describe "#generate" do
    subject(:generate) { described_class.new(data, admin).generate }

    it { is_expected.to be_a(StringIO) }
  end

  describe "#format_user" do
    subject(:format_user) { described_class.new(data, admin).format_user(exported_admin) }

    it { is_expected.to include(exported_admin.first_name) }
  end
end
