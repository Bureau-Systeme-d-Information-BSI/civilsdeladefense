class Account::UsersController < Account::BaseController
  def update
    @user = current_user
    @file_name = user_params.keys.first
    respond_to do |format|
      if @user.update(user_params)
        @user.update_column "#{@file_name}_is_validated", 0
        format.html { redirect_to [:account, :user], notice: t('.success') }
        format.js {}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.js {}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(permitted_fields)
    end

    def permitted_fields
      ary = User::FILES
      ary
    end
end
