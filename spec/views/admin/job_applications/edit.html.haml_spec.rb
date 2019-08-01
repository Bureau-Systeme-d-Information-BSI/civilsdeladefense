# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/job_applications/edit', type: :view do
  before(:each) do
    @job_application = assign(:job_application, create(:job_application))
  end

  it 'renders the edit job_application form' do
    render

    url = admin_job_application_path(@job_application)
    assert_select 'form[action=?][method=?]', url, 'post' do
      prefix = 'job_application[personal_profile_attributes]'

      assert_select 'input[name=?]', "#{prefix}[current_position]"

      assert_select 'input[name=?]', "#{prefix}[phone]"

      assert_select 'input[name=?]', "#{prefix}[address_1]"

      assert_select 'input[name=?]', "#{prefix}[address_2]"

      assert_select 'input[name=?]', "#{prefix}[postcode]"

      assert_select 'input[name=?]', "#{prefix}[city]"

      assert_select 'select[name=?]', "#{prefix}[country]"

      assert_select 'input[name=?]', "#{prefix}[website_url]"
    end
  end
end
