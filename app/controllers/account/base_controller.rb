class Account::BaseController < ApplicationController

  before_action :authenticate_user!
  layout 'account'

  def show
    redirect_to [:account, :job_applications]
  end
end
