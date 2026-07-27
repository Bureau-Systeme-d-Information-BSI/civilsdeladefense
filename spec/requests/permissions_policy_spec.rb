# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Permissions-Policy header" do
  subject(:perform) { get root_path }

  before { perform }

  it { expect(response.headers["Feature-Policy"]).to include("camera 'none'") }
end
