# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::JobApplicationFileTypes", type: :request do
  it_behaves_like "an admin setting", :job_application_file_type, :name, "a new name"
  it_behaves_like "a movable admin setting", :job_application_file_type
end
