# frozen_string_literal: true

class Admin::Settings::RightPositionsController < Admin::Settings::BaseController
  include Admin::Settings::PositionChangeable

  def create
    @item.move_right
    redirect_to_index
  end
end
