require "rails_helper"

RSpec.describe Admin::JobOffersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/job_offers").to route_to("admin/job_offers#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/job_offers/new").to route_to("admin/job_offers#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/job_offers/1").to route_to("admin/job_offers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/job_offers/1/edit").to route_to("admin/job_offers#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/admin/job_offers").to route_to("admin/job_offers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/job_offers/1").to route_to("admin/job_offers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/job_offers/1").to route_to("admin/job_offers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/job_offers/1").to route_to("admin/job_offers#destroy", :id => "1")
    end
  end
end
