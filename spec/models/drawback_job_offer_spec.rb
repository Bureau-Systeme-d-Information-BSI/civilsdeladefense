require "rails_helper"

RSpec.describe DrawbackJobOffer do
  describe "associations" do
    it { is_expected.to belong_to(:drawback) }

    it { is_expected.to belong_to(:job_offer) }
  end
end
