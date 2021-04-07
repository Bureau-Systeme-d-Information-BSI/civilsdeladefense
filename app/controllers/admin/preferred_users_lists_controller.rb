# frozen_string_literal: true

class Admin::PreferredUsersListsController < Admin::InheritedResourcesController
  layout "admin/pool"

  def index
  end

  def new
    render layout: request.xhr? ? false : "admin/pool"
  end

  def edit
    render layout: request.xhr? ? false : "admin/pool"
  end

  def create
    if resource.save
      respond_to do |format|
        format.html { redirect_to [:admin, resource] }
        format.js { render json: {}.to_json, status: :created, location: [:admin, resource] }
      end
    else
      layout_choice = request.xhr? ? false : "admin/pool"
      render action: "new", status: :unprocessable_entity, layout: layout_choice
    end
  end

  def update
    if resource.update(permitted_params)
      respond_to do |format|
        format.html { redirect_to [:admin, resource] }
        format.js { render json: {}.to_json, status: :created, location: [:admin, resource] }
      end
    else
      respond_to do |format|
        format.html do
          layout_choice = request.xhr? ? false : "admin/pool"
          render action: "edit", status: :unprocessable_entity, layout: layout_choice
        end
      end
    end
  end

  def show
    @preferred_users = @preferred_users_list.users.includes(:job_applications)
    @q = @preferred_users.ransack(params[:q])
    @preferred_users_filtered = @q.result.yield_self { |relation|
      if params[:s].present?
        relation.search_full_text(params[:s])
      else
        relation
      end
    }.yield_self { |relation|
      relation.paginate(page: params[:page])
    }

    render action: :show, layout: "admin/pool"
  end

  def destroy
    @preferred_users_list.destroy

    redirect_to %i[admin users]
  end

  protected

  def permitted_fields
    %i[name note]
  end
end
