# frozen_string_literal: true

class Admin::Settings::OrganizationsController < Admin::Settings::BaseController
  before_action :set_organization

  def edit
  end

  def edit_security
  end

  def update
    if @organization.update(general_permitted_params)
      redirect_to({action: :edit}, notice: t(".success"))
    else
      @organization_form_general = @organization
      @organization_form_display = @organization_cloned
      @organization_form_security = @organization_cloned

      render action: :edit
    end
  end

  def update_security
    if @organization.update(security_permitted_params)
      redirect_to({action: :edit_security}, notice: t(".success"))
    else
      @organization_form_general = @organization_cloned
      @organization_form_display = @organization_cloned
      @organization_form_security = @organization

      render action: :edit
    end
  end

  private

  def set_organization
    @organization = current_organization
    @organization_cloned = current_organization.clone
  end

  protected

  def general_permitted_params
    permitted_fields = %i[
      brand_name prefix_article
      service_name service_description_short service_description privacy_policy_url
      operator_name operator_url operator_logo help_file remove_help_file
      partner_1_name partner_1_url partner_1_logo
      partner_2_name partner_2_url partner_2_logo
      partner_3_name partner_3_url partner_3_logo
      remove_operator_logo remove_image_background remove_testimony_logo
      remove_partner_1_logo remove_partner_2_logo remove_partner_3_logo
      testimony_title testimony_subtitle testimony_url testimony_logo
      linkedin_url twitter_url youtube_url instagram_url facebook_url
      image_background remove_image_background
      inbound_email_config days_before_publishing
      job_offer_term_title job_offer_term_subtitle job_offer_term_warning
    ]
    params.require(:organization).permit(permitted_fields)
  end

  def security_permitted_params
    params.require(:organization).permit(:administrator_email_suffix)
  end
end
