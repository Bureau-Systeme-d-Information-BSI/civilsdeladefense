# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::JobApplicationsController do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/candidatures").to route_to("admin/job_applications#index")
    end

    it "routes to #new" do
      expect(get: "/admin/candidatures/new").to route_to("admin/job_applications#show", id: "new")
    end

    it "routes to #show" do
      expect(get: "/admin/candidatures/1").to route_to("admin/job_applications#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/admin/candidatures/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(post: "/admin/candidatures").not_to be_routable
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/candidatures/1").to route_to("admin/job_applications#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/candidatures/1").to route_to("admin/job_applications#update", id: "1")
    end

    it "routes to #change_state via PATCH" do
      expect(patch: "/admin/candidatures/1/change_state").to route_to("admin/job_applications#change_state", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/candidatures/1").not_to be_routable
    end
  end
end
