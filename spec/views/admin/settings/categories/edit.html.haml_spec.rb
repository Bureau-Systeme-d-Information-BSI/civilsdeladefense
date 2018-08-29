require 'rails_helper'

RSpec.describe "admin/settings/categories/edit", type: :view do
  before(:each) do
    @category = assign(:category, create(:category))
  end

  it "renders the edit admin/category form" do
    render_template('/admin/settings/inherited_ressources/edit')

    # assert_select "form[action=?][method=?]", admin/category_path(@admin/category), "post" do

    #   assert_select "input[name=?]", "admin/category[name]"

    #   assert_select "input[name=?]", "admin/category[position]"
    # end
  end
end
