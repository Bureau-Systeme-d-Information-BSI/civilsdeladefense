class Account::BaseController < ApplicationController

  before_action :authenticate_user!

  def show
    redirect_to [:account, :job_applications]
  end
end
