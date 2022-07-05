# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/settings/categories/new", type: :view do
  before do
    assign(:category, build(:category))
  end

  it "renders new admin/category form" do
    render_template("/admin/settings/inherited_ressources/new")

    # assert_select "form[action=?][method=?]", admin_settings_categories_path, "post" do

    #   assert_select "input[name=?]", "admin/category[name]"

    #   assert_select "input[name=?]", "admin/category[position]"
    # end
  end
end
