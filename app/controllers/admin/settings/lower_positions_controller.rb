# frozen_string_literal: true

class Admin::Settings::LowerPositionsController < Admin::Settings::BaseController
  include Admin::Settings::PositionChangeable

  def create
    @item.move_lower
    redirect_to_index
  end
end
