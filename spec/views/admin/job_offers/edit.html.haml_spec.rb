# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/job_offers/edit', type: :view do
  login_admin

  before(:each) do
    @job_offer = assign(:job_offer, create(:job_offer))
  end

  it 'renders the edit job_offer form' do
    render
  end
end
