# frozen_string_literal: true

class Admin::Settings::RighterPositionsController < Admin::Settings::BaseController
  include Admin::Settings::PositionChangeable

  def create
    @item.move_right
    redirect_to_index
  end
end
