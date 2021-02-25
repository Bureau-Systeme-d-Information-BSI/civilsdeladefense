# frozen_string_literal: true

require "rails_helper"

RSpec.describe Page, type: :model do
  before(:all) do
  end

  it { should validate_presence_of(:title) }

  it "is valid with valid attributes" do
    @organization = organizations(:cvd)
    @page = create(:page, organization: @organization)
    expect(@page).to be_valid
  end

  describe "pages tree manipulation when level > 1" do
    before(:each) do
      @organization = organizations(:cvd)
      @root_page = create(:page, organization: @organization)
      @page1 = create(:page, organization: @organization, parent: @root_page)
      @page2 = create(:page, organization: @organization, parent: @page1)
      @page3 = create(:page, organization: @organization, parent: @page2)
    end

    it "should create page trees" do
      expect(@page1.parent_id).to eq(@root_page.id)
      expect(@page2.parent_id).to eq(@page1.id)
      expect(@page3.parent_id).to eq(@page2.id)
    end

    it "should reinsert children branch" do
      @page4 = create(:page, organization: @organization, parent: @page1)

      expect(@page4.parent_id).to eq(@page1.id)
      @page2.reload
      expect(@page2.parent_id).to eq(@page4.id)
    end

    it "should move higher" do
      @page3.move_higher
      @page2.reload
      expect(@page3.parent_id).to eq(@page1.id)
      expect(@page2.parent_id).to eq(@page3.id)
    end

    it "should move lower" do
      @page2.move_lower
      @page3.reload
      expect(@page3.parent_id).to eq(@page1.id)
      expect(@page2.parent_id).to eq(@page3.id)
    end
  end

  describe "pages tree manipulation when level 1" do
    before(:each) do
      @organization = organizations(:cvd)
      @root_page = create(:page, organization: @organization)
      @branch1_page1 = create(:page, organization: @organization, parent: @root_page)
      @branch1_page2 = create(:page, organization: @organization, parent: @branch1_page1)
      @branch1_page3 = create(:page, organization: @organization, parent: @branch1_page2)

      @branch2_page1 = create(:page, organization: @organization, parent: @root_page)
      @branch2_page2 = create(:page, organization: @organization, parent: @branch2_page1)
      @branch2_page3 = create(:page, organization: @organization, parent: @branch2_page2)
    end

    it "should create page trees" do
      expect(@branch1_page1.parent_id).to eq(@root_page.id)
      expect(@branch1_page2.parent_id).to eq(@branch1_page1.id)
      expect(@branch1_page3.parent_id).to eq(@branch1_page2.id)

      expect(@branch2_page1.parent_id).to eq(@root_page.id)
      expect(@branch2_page2.parent_id).to eq(@branch2_page1.id)
      expect(@branch2_page3.parent_id).to eq(@branch2_page2.id)
    end

    it "should move higher" do
      children = @root_page.children
      expect(children.first.id).to eq(@branch1_page1.id)
      expect(children.last.id).to eq(@branch2_page1.id)

      @branch2_page1.move_higher
      @branch1_page1.reload

      children = @root_page.children
      expect(children.first.id).to eq(@branch2_page1.id)
      expect(children.last.id).to eq(@branch1_page1.id)
    end

    it "should move lower" do
      children = @root_page.children
      expect(children.first.id).to eq(@branch1_page1.id)
      expect(children.last.id).to eq(@branch2_page1.id)

      @branch1_page1.move_lower
      @branch2_page1.reload

      children = @root_page.children
      expect(children.first.id).to eq(@branch2_page1.id)
      expect(children.last.id).to eq(@branch1_page1.id)
    end
  end
end
