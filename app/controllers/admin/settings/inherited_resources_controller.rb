class Admin::Settings::InheritedResourcesController < Admin::Settings::BaseController
  respond_to :html
  inherit_resources
  actions :all, except: %i(show)

  def create
    key = "admin.settings.#{ resource_class.to_s.tableize }.create.success"
    create!(notice: t(key))
  end

  def update
    key = "admin.settings.#{ resource_class.to_s.tableize }.update.success"
    update!(notice: t(key))
  end

  def destroy
    key = "admin.settings.#{ resource_class.to_s.tableize }.destroy.success"
    destroy!(notice: t(key))
  end

  protected

    def permitted_fields
      %i(name)
    end

    def permitted_params
      params.permit(resource_class.to_s.tableize.singularize.to_sym => permitted_fields)
    end
end
