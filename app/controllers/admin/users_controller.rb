# frozen_string_literal: true

class Admin::UsersController < Admin::InheritedResourcesController
  belongs_to :preferred_users_list

  def show
    render layout: layout_choice
  end

  protected

  def layout_choice
    'admin/pool'
  end
end
