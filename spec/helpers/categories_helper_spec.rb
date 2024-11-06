require "rails_helper"

RSpec.describe CategoriesHelper do
  describe "#categories_options_for_select" do
    subject { helper.categories_options_for_select }

    let!(:cat_1) { create(:category, name: "Category 1") }
    let!(:cat_2) { create(:category, name: "Category 2") }
    let!(:cat_3) { create(:category, name: "Category 3", parent: cat_2) }

    let(:expected_options_for_select) do
      options_for_select(
        [
          [cat_1.name_with_depth, cat_1.id],
          [cat_2.name_with_depth, cat_2.id, {disabled: true}],
          [cat_3.name_with_depth, cat_3.id]
        ]
      )
    end

    it { is_expected.to eq expected_options_for_select }
  end
end
