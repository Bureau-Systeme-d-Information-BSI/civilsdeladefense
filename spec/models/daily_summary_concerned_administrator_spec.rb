# frozen_string_literal: true

require "rails_helper"

RSpec.describe DailySummaryConcernedAdministrator do
  describe "#add_summary_info" do
    subject(:add_summary_info) { concerned_administrator.add_summary_info(info) }

    let(:concerned_administrator) { described_class.new }
    let(:info) { {kind: "NewJobOffer"} }

    it { expect { add_summary_info }.to change(concerned_administrator.summary_infos, :size).by(1) }

    it { expect(add_summary_info).to eq([info]) }
  end
end
