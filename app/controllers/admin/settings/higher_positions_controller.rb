# frozen_string_literal: true

class Admin::Settings::HigherPositionsController < Admin::Settings::BaseController
  include Admin::Settings::PositionChangeable

  def create
    @item.move_higher
    redirect_to_index
  end
end
