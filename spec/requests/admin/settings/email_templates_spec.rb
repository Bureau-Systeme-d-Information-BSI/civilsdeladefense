# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::EmailTemplates", type: :request do
  it_behaves_like "an admin setting", :email_template, :subject, "a new subject"
  it_behaves_like "a movable admin setting", :email_template
end
