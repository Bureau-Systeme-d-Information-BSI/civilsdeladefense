# frozen_string_literal: true

module Admin::Settings::PositionChangeable
  extend ActiveSupport::Concern

  included do
    skip_load_and_authorize_resource
    before_action :load_item
  end

  private

  def load_item
    parent_key = request.path_parameters.keys.find { |k| k.to_s.end_with?("_id") }
    model_class = parent_key.to_s.delete_suffix("_id").classify.constantize
    @item = model_class.find(request.path_parameters[parent_key])
    authorize! :update, @item
  end

  def redirect_to_index
    redirect_to(controller: "admin/settings/#{@item.class.to_s.tableize}", action: :index)
  end
end
