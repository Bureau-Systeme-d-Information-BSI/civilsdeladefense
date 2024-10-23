class Admin::Settings::PositionsController < Admin::BaseController
  skip_load_and_authorize_resource

  # TODO: spec and refactoring

  def update
    resource = resource_class.find(params[:resource_id])
    if resource.respond_to?(:parent_id) # acts as nested set
      sibling_resource = resource_class.find_by(id: params[:next_resource_id]) if params[:next_resource_id]
      if sibling_resource
        resource.move_to_left_of(sibling_resource) if sibling_resource.root?
      else
        resource.move_to_right_of(resource_class.roots.last) # move to the end of the list
      end
      redirect_back_or_to admin_settings_root_path
    else # acts as list
      resource.insert_at(position)
      head :ok
    end
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
