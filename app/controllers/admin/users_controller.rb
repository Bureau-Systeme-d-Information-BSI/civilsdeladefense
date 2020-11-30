# frozen_string_literal: true

class Admin::UsersController < Admin::InheritedResourcesController
  def index
    @q = @users.ransack(params[:q])
    @users_filtered = @q.result.yield_self do |relation|
      if params[:s].present?
        relation.search_full_text(params[:s])
      else
        relation
      end
    end.yield_self do |relation|
      relation.includes(job_applications: %i[profile]).paginate(page: params[:page], per_page: 25)
    end

    render action: :index, layout: 'admin/pool'
  end

  def show
    render layout: 'admin/pool'
  end

  def update
    if @user.update(permitted_params)
      respond_to do |format|
        format.html { redirect_to [:admin, @user], notice: t('.success') }
        format.js do
          @notification = t('.success')
          render :update
        end
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js do
          @notification = t('.failure')
          render :update, status: :unprocessable_entity
        end
      end
    end
  end

  def listing
    render layout: 'admin/pool'
  end

  def update_listing
    if @user.update(permitted_params_listing)
      respond_to do |format|
        format.html do
          redirect_to %i[admin users], notice: t('.success')
        end
      end
    else
      respond_to do |format|
        format.html do
          render action: :listing
        end
      end
    end
  end

  def suspend
    reason = params.require(:user).permit(:suspension_reason).fetch(:suspension_reason)
    reason = nil if reason.blank?
    @user.suspend!(reason)
    redirect_back(fallback_location: [:admin, @user], notice: t('.success'))
  end

  def unsuspend
    @user.unsuspend!
    redirect_back(fallback_location: [:admin, @user], notice: t('.success'))
  end

  def destroy
    if @user.destroy
      redirect_back(fallback_location: %i[admin users], notice: t('.success'))
    else
      reason = @user.errors.full_messages.join(', ')
      msg = t('.failure', reason: reason)
      redirect_back(fallback_location: %i[admin users], notice: msg)
    end
  end

  protected

  # Never trust parameters from the scary internet, only allow the white list through.
  def permitted_params
    fields = %i[first_name last_name current_position phone website_url]
    params.require(:user).permit(fields)
  end

  def permitted_params_listing
    params.require(:user).permit(preferred_users_list_ids: [])
  end

  alias resource_params permitted_params
end
