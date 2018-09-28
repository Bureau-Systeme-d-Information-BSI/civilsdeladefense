class JobOffersController < ApplicationController
  before_action :set_job_offer, only: [:show, :apply, :send_application, :successful]

  # GET /job_offers
  # GET /job_offers.json
  def index
    @categories = Category.order('lft ASC')
    @job_offers = JobOffer.publicly_visible.includes(:contract_type)
    @job_offers = @job_offers.search_full_text(params[:q]) if params[:q].present?
    @job_offers = @job_offers.to_a
  end

  # GET /job_offers/1
  # GET /job_offers/1.json
  def show
  end

  # GET /job_offers/1/apply
  # GET /job_offers/1/apply.json
  def apply
    @job_application = JobApplication.new
    if user_signed_in?
      fields = %w(first_name last_name current_position phone address_1 address_2 postal_code city country website_url linkedin_url)
      fields.each do |field|
        value = current_user.send(field.to_sym)
        @job_application.send("#{field}=".to_sym, value)
      end
    else
      @job_application.user = User.new
    end
    @job_application.country ||= "FR"
  end

  # POST /job_offers/1/send_application
  # POST /job_offers/1/send_application.json
  def send_application
    @job_application = JobApplication.new(job_application_params)
    @job_application.job_offer = @job_offer
    @job_application.user = current_user if user_signed_in?

    if @job_application.user
      @job_application.user.first_name = @job_application.first_name
      @job_application.user.last_name = @job_application.last_name
      @job_application.user.photo = @job_application.photo
    end

    respond_to do |format|
      if @job_application.save

        @job_offer.initial! if @job_offer.start?

        format.html { redirect_to [:account, :job_applications] }
        format.json { render :show, status: :created, location: [:account, @job_application] }
      else
        format.html { render :apply }
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /job_offers/1/successful
  # GET /job_offers/1/successful.json
  def successful
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_offer
      @job_offer = JobOffer.publicly_visible.find(params[:id])
      if params[:id] != @job_offer.slug
        return redirect_to @job_offer, status: :moved_permanently
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_application_params
      permitted_params = [:first_name, :last_name, :current_position, :phone, :address_1, :address_2, :postal_code, :city, :country, :portfolio_url, :website_url, :linkedin_url, :terms_of_service]
      permitted_params << {user_attributes: [:email, :password, :password_confirmation]} unless user_signed_in?
      (JobOffer::FILES + JobOffer::URLS).each do |field|
        permitted_params << field unless @job_offer.send("disabled_option_#{field}?")
      end
      params.require(:job_application).permit(permitted_params)
    end
end
