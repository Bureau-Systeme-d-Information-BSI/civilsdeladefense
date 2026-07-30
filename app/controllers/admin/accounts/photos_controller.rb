# frozen_string_literal: true

class Admin::Accounts::PhotosController < Admin::BaseController
  skip_load_and_authorize_resource

  def show
    administrator = Administrator.find(params[:id])

    send_data(
      administrator.photo.big.read,
      filename: administrator.photo.filename,
      type: administrator.photo.content_type
    )
  end
end
