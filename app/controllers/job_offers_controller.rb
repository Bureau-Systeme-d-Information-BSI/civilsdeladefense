class JobOffersController < ApplicationController
  before_action :set_job_offer, only: [:show, :apply, :send_application, :successful]
  invisible_captcha only: [:send_application], honeypot: :subtitle

  # GET /job_offers
  # GET /job_offers.json
  def index
    @categories = Category.order('lft ASC').where('published_job_offers_count > ?', 0)
    @max_depth_limit = 1
    @categories_for_select = @categories.select{|x| x.depth <= @max_depth_limit}
    @contract_types = ContractType.all
    @job_offers = JobOffer.publicly_visible.includes(:contract_type)
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
      @job_offers = @job_offers.where(category_id: @category.self_and_descendants)
    end
    %i(contract_type_id).each do |filter|
      if params[filter].present? && (obj = filter.to_s.gsub('_id', '').classify.constantize.find(params[filter])).present?
        @job_offers = @job_offers.where(filter => obj.id)
        instance_variable_set("@#{ filter.to_s.gsub('_id', '') }", obj)
      end
    end
    @job_offers = @job_offers.search_full_text(params[:q]) if params[:q].present?
    @job_offers = @job_offers.to_a

    respond_to do |format|
      format.html {}
      format.js {}
      format.json { render @job_offers.to_json }
    end
  end

  # GET /job_offers/1
  # GET /job_offers/1.json
  def show
  end

  # GET /job_offers/1/apply
  # GET /job_offers/1/apply.json
  def apply
    if user_signed_in? && (@previous_job_application = current_user.job_applications.first)
      @job_application = @previous_job_application.dup
      @job_application.state = JobApplication.new.state
    else
      @job_application = JobApplication.new
      @job_application.user = User.new
      @job_application.country = "FR"
    end
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
    end

    respond_to do |format|
      if @job_application.save

        @job_offer.initial! if @job_offer.start?

        job_offer_identifier = @job_offer.identifier
        subject = t('job_offers.successful.subject', job_offer_identifier: job_offer_identifier)
        body = t('job_offers.successful.body', first_name: @job_application.first_name, job_offer_title: @job_offer.title, job_offer_identifier: job_offer_identifier)
        email = @job_application.emails.create(subject: subject, body: body)
        ApplicantNotificationsMailer.new_email(email.id).deliver_now

        format.html { redirect_to [:account, :job_applications] }
        format.json { render json: @job_application.to_json(only: %i(id)), status: :created, location: [:successful, @job_offer] }
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
      @job_offer = JobOffer.find(params[:id])
      if !@job_offer.published? && params[:preview].blank?
        raise JobOfferNotAvailableAnymore.new(job_offer_title: @job_offer.title)
      end
      if params[:id] != @job_offer.slug
        return redirect_to @job_offer, status: :moved_permanently
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_application_params
      permitted_params = [:first_name, :last_name, :current_position, :phone, :address_1, :address_2, :postal_code, :city, :country, :website_url, :terms_of_service, :certify_majority]
      permitted_params << {user_attributes: [:photo, :email, :password, :password_confirmation]} unless user_signed_in?
      permitted_params << {job_application_files_attributes: [:content, :job_application_file_type_id]}
      (JobOffer::FILES + JobOffer::URLS).each do |field|
        permitted_params << field unless @job_offer.send("disabled_option_#{field}?")
      end
      params.require(:job_application).permit(permitted_params)
    end
end
