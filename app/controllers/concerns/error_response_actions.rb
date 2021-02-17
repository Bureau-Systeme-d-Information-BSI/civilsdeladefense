# frozen_string_literal: true

module ErrorResponseActions
  ERROR_RESPONSE_ACTIONS = %(authentication_error
                             authorization_error
                             bad_request
                             resource_not_found
                             page_not_found
                             not_implmented
                             route_not_found
                             method_not_allowed
                             resource_not_available_anymore)

  # def authentication_error
  #   respond_to do |format|
  #     format.html do
  #       flash[:error] = 'You are not logged in.'
  #       session[:user_return_to] = request.fullpath
  #       redirect_to new_user_session_path
  #     end
  #     # 401 Unauthorized response
  #     format.any(:json, :xml){ request_http_basic_authentication 'My Application' }
  #   end
  # end

  def authorization_error
    # 403 Forbidden response
    respond_to do |format|
      format.html { render 'errors/error_403', status: 403 }
      format.pdf { render plain: 'Not Authorized', status: 403, layout: false }
      format.xml  { render xml: 'Access Denied', status: 403 }
      format.json { render json: 'Access Denied', status: 403 }
    end
  end

  # 400 Bad Request
  def bad_request(exception)
    @page_title = "Cette offre n'est plus disponible" if exception&.data
    respond_to do |format|
      format.html { render 'errors/error_400', status: 400, layout: 'error' }
      format.pdf { render plain: 'Bad Request', status: 400, layout: false }
      format.xml  { render xml: 'Bad Request', status: 400 }
      format.json { render json: { errors: exception.data }, status: 400 }
    end
  end

  def resource_not_found
    respond_to do |format|
      format.html { render 'errors/error_404', status: 404, layout: 'error' }
      format.xml  { render xml: 'Record Not Found', status: 404 }
      format.json { render json: 'Record Not Found', status: 404 }
    end
  end

  def resource_not_available_anymore(exception)
    @page_title = "Cette offre n'est plus disponible" if exception&.data
    respond_to do |format|
      format.html { render 'errors/error_404', status: 404, layout: 'error' }
      format.xml  { render xml: 'Record Not Found', status: 404 }
      format.json { render json: 'Record Not Found', status: 404 }
    end
  end

  def page_not_found
    respond_to do |format|
      format.html { render 'errors/error_404', status: 404, layout: 'error' }
      format.xml  { render xml: 'Record Not Found', status: 404 }
      format.json { render json: 'Record Not Found', status: 404 }
    end
  end

  # def not_implemented(allowed_methods)
  #   method_not_allowed(allowed_methods, 'Not Implemented', 501)
  # end

  # def method_not_allowed(allowed_methods, message = 'Method Not Allowed', status=405)
  #   response.headers['Allow'] ||= allowed_methods.map { |method_symbol| method_symbol.to_s.upcase } * ', '
  #   respond_to do |format|
  #     format.html{ render :template=>'/rescues/method_not_allowed', status: status }
  #     format.xml{  render xml: message,                          status: status }
  #     format.json{ render json: message,                         status: status }
  #   end
  # end

  # def route_not_found
  #   method, path = env['REQUEST_METHOD'].downcase.to_sym, env['PATH_INFO']

  #   # Route was not recognized. Try to find out why (maybe wrong verb).
  #   allows = ActionDispatch::Routing::HTTP_METHODS.select { |verb|
  #     begin
  #       match = Rails.application.routes.recognize_path(path, :method => verb)
  #       match[:action] != 'route_not_found'
  #     rescue ActionController::RoutingError
  #       nil
  #     end
  #   }

  #   if !allows.empty? && !ActionDispatch::Routing::HTTP_METHODS.include?(method)
  #     not_implmented allows
  #     # raise ActionController::NotImplemented.new(*allows)
  #   elsif !allows.empty?
  #     method_not_allowed allows
  #     # raise ActionController::MethodNotAllowed.new(*allows)
  #   else
  #     if Rails.configuration.consider_all_requests_local
  #       response.headers['X-Cascade'] = 'pass'
  #       render :nothing => true, status: 404
  #     else
  #       page_not_found
  #     end
  #   end
  # end
end
