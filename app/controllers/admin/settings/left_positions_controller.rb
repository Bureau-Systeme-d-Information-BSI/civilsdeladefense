# frozen_string_literal: true

class Admin::Settings::LeftPositionsController < Admin::Settings::BaseController
  include Admin::Settings::PositionChangeable

  def create
    @item.move_left
    redirect_to_index
  end
end
