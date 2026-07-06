# frozen_string_literal: true

class Account::Users::EmailsController < Account::BaseController
  def edit
    @user_for_email_change = current_user
  end

  def update
    if current_user.update(email_params)
      redirect_to account_user_path, notice: t(".success")
    else
      @user_for_password_change = User.new
      @user_for_deletion = User.new
      @user_for_email_change = current_user
      render "account/users/show"
    end
  end

  private

  def email_params
    params.expect(user: %i[email])
  end
end
