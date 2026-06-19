# frozen_string_literal: true

class Account::UsersController < Account::BaseController
  before_action :set_user, only: %i[
    show change_email update update_email destroy edit
  ]

  def show
    @user_for_password_change = User.new
    @user_for_email_change = User.new
    @user_for_deletion = User.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to %i[edit account user], notice: t(".success") }
        format.js {}
        format.json { render :edit, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.js {}
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  def change_email
  end

  def update_email
    respond_to do |format|
      if @user.update(user_email_params)
        format.html { redirect_to %i[account user], notice: t(".success") }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html do
          @user_for_password_change = User.new
          @user_for_deletion = User.new
          @user_for_email_change = @user
          render :show
        end
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  def destroy
    if @user.destroy_with_password(user_destroy_params[:current_password])
      redirect_to root_url, notice: t(".success")
    else
      @user_for_password_change = User.new
      @user_for_email_change = User.new
      @user_for_deletion = @user

      render :want_destroy
    end
  end

  def unlink_france_connect
    current_user.omniauth_informations.where(provider: :france_connect).destroy_all

    redirect_to %i[account user], notice: t(".success")
  end

  def photo
    send_data(
      current_user.photo.big.read,
      filename: current_user.photo.filename,
      type: current_user.photo.content_type
    )
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    filtered_params = params.require(:user).permit(
      :gender,
      :first_name,
      :last_name,
      :phone,
      :website_url,
      :current_position,
      :photo,
      :delete_photo,
      :address,
      :postal_code,
      :city,
      profile_attributes: %i[id gender]
    )

    filtered_params = filtered_params.except(:first_name, :last_name) unless @user.name_editable?

    if filtered_params[:photo].present? || filtered_params[:delete_photo] == "0"
      filtered_params.except(:delete_photo)
    else
      filtered_params.except(:photo)
    end
  end

  def user_email_params
    params.require(:user).permit(:email)
  end

  def user_destroy_params
    params.require(:user).permit(:current_password)
  end
end
