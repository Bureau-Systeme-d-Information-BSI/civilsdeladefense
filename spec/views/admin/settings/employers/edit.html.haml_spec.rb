# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/settings/employers/edit", type: :view do
  before(:each) do
    @employer = assign(:employer, create(:employer))
  end

  it "renders the edit admin/settings_employer form" do
    render_template("/admin/settings/inherited_ressources/edit")

    # assert_select "form[action=?][method=?]", admin/settings_employer_path(@admin/settings_employer), "post" do

    #   assert_select "input[name=?]", "admin/settings_employer[name]"
    # end
  end
end
