# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Settings::CategoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/parametres/categories").to route_to("admin/settings/categories#index")
    end

    it "routes to #new" do
      expect(get: "/admin/parametres/categories/new").to route_to("admin/settings/categories#new")
    end

    it "routes to #edit" do
      expect(get: "/admin/parametres/categories/1/edit").to route_to("admin/settings/categories#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/admin/parametres/categories").to route_to("admin/settings/categories#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/parametres/categories/1").to route_to("admin/settings/categories#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/parametres/categories/1").to route_to("admin/settings/categories#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/parametres/categories/1").to route_to("admin/settings/categories#destroy", id: "1")
    end
  end
end
