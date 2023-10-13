# frozen_string_literal: true

require "rails_helper"

RSpec.describe Recipient do
  it "loads the user when instiated with an id" do
    job_application = create(:job_application)
    expect(described_class.new(id: job_application.id).user).to be_present
  end
end
