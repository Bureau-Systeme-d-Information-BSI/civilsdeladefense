# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe RemoveResumeJobApplicationFileTypeTask do
    describe "#process" do
      subject(:process) { described_class.process(element) }
      let!(:element) { create(:job_application_file_type, name: "CV") }

      it { expect { process }.to change(JobApplicationFileType, :count).by(-1) }
    end
  end
end
