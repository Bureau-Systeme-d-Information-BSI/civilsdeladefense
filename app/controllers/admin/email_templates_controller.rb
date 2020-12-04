# frozen_string_literal: true

class Admin::EmailTemplatesController < Admin::BaseController
  def index
    template_id = params.require(:email).permit(:template)[:template]
    @email_template = EmailTemplate.find template_id
    render json: @email_template.to_json
  end
end
