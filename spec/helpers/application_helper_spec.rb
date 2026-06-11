require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#header_offers_active?" do
    subject { helper.header_offers_active?(controller_name, action_name, job_offer: job_offer) }

    context "when controller_name is job_offers and action_name is index" do
      let(:controller_name) { "job_offers" }
      let(:action_name) { "index" }
      let(:job_offer) { nil }

      it { is_expected.to be_truthy }
    end

    context "when controller_name is job_offers and action_name is show and job_offer is not spontaneous" do
      let(:controller_name) { "job_offers" }
      let(:action_name) { "show" }
      let(:job_offer) { instance_double(JobOffer, spontaneous?: false) }

      it { is_expected.to be_truthy }
    end

    context "when controller_name is job_offers and action_name is show and job_offer is spontaneous" do
      let(:controller_name) { "job_offers" }
      let(:action_name) { "show" }
      let(:job_offer) { instance_double(JobOffer, spontaneous?: true) }

      it { is_expected.to be_falsey }
    end

    context "when controller_name is not job_offers" do
      let(:controller_name) { "other" }
      let(:action_name) { "index" }
      let(:job_offer) { nil }

      it { is_expected.to be_falsey }
    end
  end

  describe "#header_spontaneous_active?" do
    subject { helper.header_spontaneous_active?(controller_name, action_name, job_offer: job_offer) }

    context "when controller_name is job_offers and action_name is show and job_offer is spontaneous" do
      let(:controller_name) { "job_offers" }
      let(:action_name) { "show" }
      let(:job_offer) { instance_double(JobOffer, spontaneous?: true) }

      it { is_expected.to be_truthy }
    end

    context "when controller_name is job_offers and action_name is show and job_offer is not spontaneous" do
      let(:controller_name) { "job_offers" }
      let(:action_name) { "show" }
      let(:job_offer) { instance_double(JobOffer, spontaneous?: false) }

      it { is_expected.to be_falsey }
    end

    context "when controller_name is not job_offers" do
      let(:controller_name) { "other" }
      let(:action_name) { "index" }
      let(:job_offer) { nil }

      it { is_expected.to be_falsey }
    end
  end

  describe "#header_bookmarks_active?" do
    subject { helper.header_bookmarks_active?("job_offers", "index") }

    let(:request) { instance_double(ActionDispatch::Request, params: {bookmarked:}) }

    before { allow(helper).to receive(:request).and_return(request) }

    context "when controller_name is job_offers and action_name is index and request.params[:bookmarked] is present" do
      let(:bookmarked) { true }

      it { is_expected.to be_truthy }
    end

    context "when controller_name is job_offers and action_name is index and request.params[:bookmarked] is blank" do
      let(:bookmarked) { nil }

      it { is_expected.to be_falsey }
    end
  end

  describe "#time_ago_in_words_minimal" do
    subject(:time_ago_in_words_minimal) { helper.time_ago_in_words_minimal(time) }

    context "when the duration is expressed in minutes" do
      let(:time) { 5.minutes.ago }

      it { is_expected.to eq("5 min") }
    end

    context "when the duration is expressed in hours" do
      let(:time) { 3.hours.ago }

      it { is_expected.to eq("environ 3 h") }
    end

    context "when the duration is expressed in months" do
      let(:time) { 2.months.ago }

      it { is_expected.to eq("2 m") }
    end

    context "when the duration is expressed in another unit" do
      let(:time) { 4.days.ago }

      it { is_expected.to eq("4 jours") }
    end
  end

  describe "#spinner_svg" do
    subject(:spinner_svg) { helper.spinner_svg }

    it { is_expected.to include("<svg") }
  end

  describe "#spinner" do
    subject(:spinner) { helper.spinner }

    it { is_expected.to be_html_safe }

    it { is_expected.to include(%(<div class="indeterminate-circle mini text-primary">)) }
  end

  describe "#will_paginate" do
    subject(:will_paginate) { helper.will_paginate(collection) }

    let(:collection) { WillPaginate::Collection.create(1, 1, 3) { |pager| pager.replace([1]) } }

    before { helper.controller.request.path_parameters = {controller: "job_offers", action: "index"} }

    it { is_expected.to include("pagination") }
  end

  describe "#simple_form_for" do
    subject(:simple_form_for) { helper.simple_form_for(JobOffer.new, url: "/job_offers") { |form| form.input(:title) } }

    it { is_expected.to include(%(data-turbo="false")) }
  end
end
