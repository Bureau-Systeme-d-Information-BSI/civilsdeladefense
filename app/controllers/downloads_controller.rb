# frozen_string_literal: true

class DownloadsController < ApplicationController
  before_action :authenticate_request

  def show = send_data(attribute.read, filename: attribute.filename, type: attribute.content_type)

  private

  def authenticate_request
    head :unauthorized unless request.headers["X-Download-Secret-Key"] == ENV["DOWNLOAD_SECRET_KEY"]
  end

  def resource = @resource ||= sanitize_resource_type.find(params[:id])

  def attribute = @attribute ||= sanitize_attribute

  def sanitize_resource_type
    case params[:resource_type]
    when "User"
      User
    when "Profile"
      Profile
    when "JobApplicationFile"
      JobApplicationFile
    else
      throw "Invalid resource type"
    end
  end

  def sanitize_attribute
    case params[:attribute_name]
    when "photo"
      resource.photo
    when "resume"
      resource.resume
    when "content"
      resource.content
    else
      throw "Invalid attribute"
    end
  end
end
