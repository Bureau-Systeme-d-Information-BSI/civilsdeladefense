# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::JobOffers" do
  subject(:show_request) { get account_job_application_job_offer_path(job_application) }

  let(:user) { create(:confirmed_user) }
  let(:job_application) { create(:job_application, user:) }

  before do
    sign_in user
    show_request
  end

  it { expect(response).to be_successful }

  it { expect(response).to render_template(:show) }
end
