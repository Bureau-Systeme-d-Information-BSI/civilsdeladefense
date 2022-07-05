# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/settings/categories/index", type: :view do
  before do
    existing_categories = Category.all
    if existing_categories.any?
      assign(:categories, existing_categories)
    else
      assign(:categories, create_list(:category, 5))
    end
  end

  it "renders a list of admin/settings/categories" do
    render_template("/admin/settings/inherited_ressources/index")
    # assert_select "tr>td", :text => "Name".to_s, :count => 2
    # assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
