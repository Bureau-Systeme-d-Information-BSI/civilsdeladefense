# frozen_string_literal: true

# FranceConnect v2 returns userinfo as a signed JWT (JWS) instead of plain JSON.
# This monkey-patch decodes the JWT response before processing.

module OpenIDConnect
  class AccessToken < Rack::OAuth2::AccessToken::Bearer
    private

    alias_method :original_resource_request, :resource_request

    def resource_request
      res = yield
      case res.status
      when 200
        body = res.body
        # If the response is a JWT string, decode it
        if body.is_a?(String) && body.match?(/\A[\w-]+\.[\w-]+\.[\w-]+\z/)
          decoded = JSON::JWT.decode(body, :skip_verification)
          decoded.to_hash.with_indifferent_access
        elsif body.is_a?(String)
          JSON.parse(body).with_indifferent_access
        else
          body.with_indifferent_access
        end
      when 400
        raise BadRequest.new("API Access Failed", res)
      when 401
        raise Unauthorized.new("Access Token Invalid or Expired", res)
      when 403
        raise Forbidden.new("Insufficient Scope", res)
      else
        raise HttpError.new(res.status, "Unknown HttpError", res)
      end
    end
  end
end
