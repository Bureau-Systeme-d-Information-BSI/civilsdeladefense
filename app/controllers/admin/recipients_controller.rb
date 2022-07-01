# frozen_string_literal: true

class Admin::RecipientsController < Admin::BaseController
  load_and_authorize_resource :job_offer

  def index
    respond_to do |format|
      format.json {
        render json: recipients(params[:s]).to_json(
          only: :id,
          include: {
            user: {
              only: %i[first_name last_name email]
            }
          }
        )
      }
    end
  end

  def create
  end

  private

  def recipient_params
    params.require(:recipient).permit(:id).to_h.symbolize_keys
  end

  def recipients(query)
    @job_offer.job_applications.search_users(query)
  end
end
