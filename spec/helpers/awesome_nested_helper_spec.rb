# frozen_string_literal: true

require "rails_helper"

RSpec.describe AwesomeNestedHelper do
  describe "#grouped_nested_set_options" do
    subject(:grouped_nested_set_options) { helper.grouped_nested_set_options(input) { |node| node.name } }

    let!(:root) { create(:category, name: "A") }
    let!(:branch_b) { create(:category, name: "B", parent: root) }
    let!(:leaf_d) { create(:category, name: "D", parent: branch_b) }
    let!(:leaf_e) { create(:category, name: "E", parent: branch_b) }

    let(:expected) { [["A", []], ["B", [["D", leaf_d.id], ["E", leaf_e.id]]], ["C", []]] }

    before { create(:category, name: "C", parent: root) }

    context "when given the model class" do
      let(:input) { Category }

      it { is_expected.to eq(expected) }
    end

    context "when given an array of nodes" do
      let(:input) { Category.order(:lft).to_a }

      it { is_expected.to eq(expected) }
    end
  end

  describe "#nested_li" do
    subject(:nested_li) { helper.nested_li(objects) { |node, _level| node.name } }

    context "when the model class has no records" do
      let(:objects) { Category }

      it { is_expected.to eq("") }
    end

    context "when given an empty array" do
      let(:objects) { [] }

      it { is_expected.to eq("") }
    end
  end

  describe "#sorted_nested_li" do
    subject(:sorted_nested_li) { helper.sorted_nested_li(Category, :name) { |node, _level| node.name } }

    it { is_expected.to eq("") }
  end
end
