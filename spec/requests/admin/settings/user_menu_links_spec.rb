# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::UserMenuLinks", type: :request do
  it_behaves_like "an admin setting", :user_menu_link, :name, "a new name"
  it_behaves_like "a movable admin setting", :user_menu_link
end
