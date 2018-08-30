require 'rails_helper'

RSpec.describe "admin/settings/employers/new", type: :view do
  before(:each) do
    assign(:employer, build(:employer))
  end

  it "renders new admin/employer form" do
    render_template('/admin/settings/inherited_ressources/new')

    # assert_select "form[action=?][method=?]", admin_settings_employers_path, "post" do

    #   assert_select "input[name=?]", "admin/settings_employer[name]"
    # end
  end
end
