require "rails_helper"

RSpec.describe Admin::JobApplicationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/candidatures").to route_to("admin/job_applications#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/candidatures/new").to route_to("admin/job_applications#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/candidatures/1").to route_to("admin/job_applications#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/candidatures/1/edit").to route_to("admin/job_applications#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/admin/candidatures").to route_to("admin/job_applications#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/candidatures/1").to route_to("admin/job_applications#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/candidatures/1").to route_to("admin/job_applications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/candidatures/1").to route_to("admin/job_applications#destroy", :id => "1")
    end
  end
end
