# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Robots" do
  describe "GET /robots" do
    subject { get robots_path(format: :txt) }

    it { is_expected.to render_template(:show) }
  end
end
