# frozen_string_literal: true

module ErrorResponseActions
  # 403 Forbidden response
  def authorization_error
    respond_to do |format|
      format.html { render "errors/error_403", status: :forbidden }
      format.pdf { render plain: "Not Authorized", status: :forbidden, layout: false }
      format.xml { render xml: "Access Denied", status: :forbidden }
      format.json { render json: "Access Denied", status: :forbidden }
    end
  end

  # 400 Bad Request
  def bad_request(exception)
    @page_title = "Cette offre n'est plus disponible" if exception&.data
    respond_to do |format|
      format.html { render "errors/error_400", status: :bad_request, layout: "error" }
      format.pdf { render plain: "Bad Request", status: :bad_request, layout: false }
      format.xml { render xml: "Bad Request", status: :bad_request }
      format.json { render json: {errors: exception.data}, status: :bad_request }
    end
  end

  # 404 Forbidden response
  def resource_not_found
    respond_to do |format|
      format.html { render "errors/error_404", status: :not_found, layout: "error" }
      format.xml { render xml: "Record Not Found", status: :not_found }
      format.json { render json: "Record Not Found", status: :not_found }
    end
  end

  def resource_not_available_anymore(exception)
    @page_title = "Cette offre n'est plus disponible" if exception&.data
    respond_to do |format|
      format.html { render "errors/error_404", status: :not_found, layout: "error" }
      format.xml { render xml: "Record Not Found", status: :not_found }
      format.json { render json: "Record Not Found", status: :not_found }
    end
  end

  # 500 Internal error
  def internal_error
    respond_to do |format|
      format.html { render "errors/error_500", status: :internal_server_error, layout: "error" }
      format.xml { render xml: "Internal Error", status: :internal_server_error }
      format.json { render json: "Internal Error", status: :internal_server_error }
    end
  end
end
