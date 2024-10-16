class Admin::Settings::PositionsController < Admin::BaseController
  skip_load_and_authorize_resource

  def update
    resource = resource_class.find(params[:resource_id])
    resource.insert_at(position)
    head :ok
  end

  private

  def resource_class = safe_resource_class.classify.constantize

  def safe_resource_class
    Zeitwerk::Loader.eager_load_all
    if ApplicationRecord.descendants.map(&:to_s).include?(params[:resource_class])
      params[:resource_class]
    else
      raise ActionController::RoutingError, "Not Found"
    end
  end

  def position = params[:position].to_i
end
