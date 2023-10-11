# frozen_string_literal: true

require "rails_helper"

RSpec.describe DomainValidationsController do
  describe "GET /.well-known/pki-validation/:file_name" do
    context "when there is a matching environment variable prefixed with DOMAIN_VALIDATION_" do
      let(:file_name) { "a_file" }
      let(:value) { "hello world" }

      before { ENV["DOMAIN_VALIDATION_#{file_name.upcase}"] = value }

      it "returns the environment variable value as plain text" do
        get domain_validations_path(file_name, format: :txt)
        expect(response.headers["Content-Type"]).to eq("text/plain; charset=utf-8")
        expect(response.body).to eq(value)
      end
    end

    context "when there is no matching environment variable prefixed with DOMAIN_VALIDATION_" do
      it "returns an empty content as plain text" do
        get domain_validations_path("unknown", format: :txt)
        expect(response.headers["Content-Type"]).to eq("text/plain; charset=utf-8")
        expect(response.body).to eq("")
      end
    end
  end
end
