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
      assert_select 'input[name=?]', 'job_application[first_name]'

      assert_select 'input[name=?]', 'job_application[last_name]'

      assert_select 'input[name=?]', 'job_application[current_position]'

      assert_select 'input[name=?]', 'job_application[phone]'

      assert_select 'input[name=?]', 'job_application[address_1]'

      assert_select 'input[name=?]', 'job_application[address_2]'

      assert_select 'input[name=?]', 'job_application[postal_code]'

      assert_select 'input[name=?]', 'job_application[city]'

      assert_select 'select[name=?]', 'job_application[country]'

      assert_select 'input[name=?]', 'job_application[website_url]'
    end
  end
end
