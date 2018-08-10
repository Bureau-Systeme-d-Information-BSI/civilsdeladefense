class Admin::Settings::BaseController < Admin::BaseController

  def index
    @administrators = Administrator.all
  end
end
