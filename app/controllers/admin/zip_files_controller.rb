# frozen_string_literal: true

class Admin::ZipFilesController < Admin::BaseController
  skip_load_and_authorize_resource

  def show
    @zip_file = ZipFile.find_by(id: params[:id])
    respond_to do |format|
      format.html
      format.json do
        render json: {download_url: @zip_file&.zip&.url}
      end
    end
  end
end
