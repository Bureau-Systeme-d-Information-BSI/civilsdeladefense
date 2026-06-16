# frozen_string_literal: true

class JobOffers::JobApplicationsController < ApplicationController
  before_action :set_job_offer
  invisible_captcha only: [:create], honeypot: :subtitle
  layout "job_offer_display"

  def show
  end

  def new
    store_location_for(:user, request.fullpath)
    if user_signed_in? && (previous_job_application = current_user.job_applications.first)
      @job_application = previous_job_application.dup
      @job_application.state = JobApplication.new.state
    else
      @job_application = JobApplication.new
      @job_application.user = user_signed_in? ? current_user : User.new
    end
    @job_application.user.build_profile if @job_application.user.profile.nil?
  end

  def create
    @job_application = JobApplication.new(job_application_params)
    @job_application.job_offer = @job_offer
    @job_application.organization = @job_offer.organization
    @job_application.user = current_user if user_signed_in?
    @job_application.user.organization = current_organization unless user_signed_in?

    if user_signed_in?
      @job_application.user.profile.profile_foreign_languages = []
      @job_application.user.profile.category_experience_levels = []
      if job_application_params[:user_attributes].present?
        @job_application.user.assign_attributes(
          job_application_params[:user_attributes].except(:profile_attributes)
        )
      end
      @job_application.user.profile.assign_attributes(
        job_application_params[:user_attributes][:profile_attributes].except(:department_profiles_attributes)
      )
      @job_application.user.profile.departments = departments
    end

    respond_to do |format|
      if @job_application.save(context: :profile)
        @job_offer.initial! if @job_offer.start?
        @job_application.send_confirmation_email
        format.html { redirect_to job_offer_job_application_path(@job_offer) }
        format.json do
          json = @job_application.to_json(only: %i[id])
          render json: json, status: :created, location: job_offer_job_application_path(@job_offer)
        end
      else
        format.turbo_stream do
          instruction = turbo_stream.replace(@job_application, partial: "/job_applications/form")
          render turbo_stream: instruction
        end
        format.html { render :new }
        format.json { render json: @job_application.errors, status: :unprocessable_content }
      end
    end
  end

  private

  def set_job_offer
    @job_offer = JobOffer.find(params[:job_offer_id])
    if !@job_offer.published? && !always_display_job_offer(@job_offer)
      raise JobOfferNotAvailableAnymore.new(job_offer_title: @job_offer.title)
    end
    redirect_to @job_offer, status: :moved_permanently if params[:job_offer_id] != @job_offer.slug
  end

  def always_display_job_offer(job_offer)
    administrator_signed_in? || (user_signed_in? && current_user.already_applied?(job_offer))
  end

  def job_application_params
    params.require(:job_application).permit(
      :category_id,
      :cover_letter,
      user_attributes: [
        :first_name,
        :last_name,
        :phone,
        :website_url,
        :photo,
        :email,
        :password,
        :password_confirmation,
        :terms_of_service,
        :certify_majority,
        :receive_job_offer_mails,
        profile_attributes: [
          :gender,
          :has_corporate_experience,
          :age_range_id,
          :availability_range_id,
          :experience_level_id,
          :study_level_id,
          :resume,
          profile_foreign_languages_attributes: [
            :foreign_language_id,
            :foreign_language_level_id
          ],
          category_experience_levels_attributes: [
            :category_id,
            :experience_level_id
          ],
          department_profiles_attributes: %i[department_id]
        ]
      ],
      job_application_files_attributes: [
        :content,
        :job_application_file_type_id,
        :job_application_file_existing_id,
        :do_not_provide_immediately
      ]
    )
  end

  def departments = Department.where(id: department_ids)

  def department_ids = department_profiles_attributes&.to_unsafe_h&.map { |_, department| department[:department_id] }

  def department_profiles_attributes
    job_application_params.dig(:user_attributes, :profile_attributes, :department_profiles_attributes)
  end
end
