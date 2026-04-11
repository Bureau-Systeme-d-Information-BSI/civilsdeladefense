# frozen_string_literal: true

class Admin::Settings::JobApplicationFileTypesController < Admin::Settings::InheritedResourcesController
  # rubocop:enable Layout/LineLength

  def new
    build_resource
    build_visibility_rules
  end

  def edit
    resource
    build_visibility_rules
  end

  def create
    build_resource
    if resource.save
      redirect_to collection_url, notice: t(".success")
    else
      build_visibility_rules
      render :new, status: :unprocessable_content
    end
  end

  def update
    if resource.update(permitted_params)
      redirect_to collection_url, notice: t(".success")
    else
      build_visibility_rules
      render :edit, status: :unprocessable_content
    end
  end

  protected

  def permitted_fields
    [
      :name,
      :description,
      :kind,
      :content,
      :required,
      :notification,
      visibility_rules_attributes: [:id, :by, :state, :_destroy]
    ]
  end

  private

  def build_visibility_rules
    @visibility_rules_for_administrator = JobApplication.states.keys.map do |state|
      find_or_initialize_by(by: :administrator, state:)
    end
    @visibility_rules_for_user = JobApplication.states.keys.map do |state|
      find_or_initialize_by(by: :user, state:)
    end
  end

  def find_or_initialize_by(by:, state:)
    @job_application_file_type.visibility_rules.find_or_initialize_by(by:, state:)
  end
end
