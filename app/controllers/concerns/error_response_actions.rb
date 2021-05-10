# frozen_string_literal: true

module ErrorResponseActions
  # 403 Forbidden response
  def authorization_error
    respond_to do |format|
      format.html { render "errors/error_403", status: 403 }
      format.pdf { render plain: "Not Authorized", status: 403, layout: false }
      format.xml { render xml: "Access Denied", status: 403 }
      format.json { render json: "Access Denied", status: 403 }
    end
  end

  # 400 Bad Request
  def bad_request(exception)
    @page_title = "Cette offre n'est plus disponible" if exception&.data
    respond_to do |format|
      format.html { render "errors/error_400", status: 400, layout: "error" }
      format.pdf { render plain: "Bad Request", status: 400, layout: false }
      format.xml { render xml: "Bad Request", status: 400 }
      format.json { render json: {errors: exception.data}, status: 400 }
    end
  end

  # 404 Forbidden response
  def resource_not_found
    respond_to do |format|
      format.html { render "errors/error_404", status: 404, layout: "error" }
      format.xml { render xml: "Record Not Found", status: 404 }
      format.json { render json: "Record Not Found", status: 404 }
    end
  end

  def resource_not_available_anymore(exception)
    @page_title = "Cette offre n'est plus disponible" if exception&.data
    respond_to do |format|
      format.html { render "errors/error_404", status: 404, layout: "error" }
      format.xml { render xml: "Record Not Found", status: 404 }
      format.json { render json: "Record Not Found", status: 404 }
    end
  end

  # 500 Internal error
  def internal_error
    respond_to do |format|
      format.html { render "errors/error_500", status: 500, layout: "error" }
      format.xml { render xml: "Internal Error", status: 500 }
      format.json { render json: "Internal Error", status: 500 }
    end
  end
end
