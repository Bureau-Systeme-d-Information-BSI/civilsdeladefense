# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/settings/employers/index', type: :view do
  before(:each) do
    assign(:employers, [
             create(:employer),
             create(:employer)
           ])
  end

  it 'renders a list of admin/settings/employers' do
    render_template('/admin/settings/inherited_ressources/index')
    # assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
