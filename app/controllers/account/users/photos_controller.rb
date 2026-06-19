# frozen_string_literal: true

class Account::Users::PhotosController < Account::BaseController
  def show
    send_data(
      current_user.photo.big.read,
      filename: current_user.photo.filename,
      type: current_user.photo.content_type
    )
  end
end
