# frozen_string_literal: true

require "rails_helper"
require "rack/test"

RSpec.describe "JobOffers" do
  describe "GET /job_offers" do
    it "returns 200 when fetching the job offers page" do
      get job_offers_path
      expect(response).to have_http_status(:ok)
    end

    describe "edge cases" do
      it "doesn't crash when contract_start_on is badly formated" do
        expect { get job_offers_path(contract_start_on: :test) }.not_to raise_error
      end

      it "doesn't crash when published_at is badly formated" do
        expect { get job_offers_path(published_at: :test) }.not_to raise_error
      end

      it "doesn't crash when page is badly formated" do
        expect { get job_offers_path(page: :test) }.not_to raise_error
        expect { get job_offers_path(page: nil) }.not_to raise_error
        expect { get job_offers_path(page: "") }.not_to raise_error
      end
    end
  end

  describe "GET /job_offers/:id" do
    it "returns 200 when fetching a specific job offers page" do
      job_offer = create(:job_offer)
      job_offer.publish!
      get job_offer_path(job_offer)
      expect(response).to have_http_status(:ok)
    end

    context "when getting the job offer as PDF" do
      subject(:get_request) { get job_offer_path(job_offer.slug, format: :pdf) }

      let(:job_offer) { create(:published_job_offer) }

      before { get_request }

      it { expect(response).to have_http_status(:ok) }

      it { expect(response.content_type).to eq("application/pdf") }
    end
  end

  describe "GET /job_offers/apply?id=:id" do
    it "returns 200 when fetching a specific job offers application page" do
      job_offer = create(:job_offer)
      job_offer.publish!
      get apply_job_offers_path(id: job_offer.slug)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "the requests support CORS headers" do
    include Rack::Test::Methods

    it "returns the response CORS headers" do
      get root_path, nil, "HTTP_ORIGIN" => "*" # rubocop:disable Rails/HttpPositionalArguments
      expect(last_response.headers["Access-Control-Allow-Origin"]).to be_nil

      get job_offers_path(format: :json), nil, "HTTP_ORIGIN" => "*" # rubocop:disable Rails/HttpPositionalArguments
      expect(last_response.headers["Access-Control-Allow-Origin"]).to eq("*")
    end

    it "Send the CORS preflight OPTIONS request" do
      headers = {
        "HTTP_ORIGIN" => "*",
        "HTTP_ACCESS_CONTROL_REQUEST_METHOD" => "GET",
        "HTTP_ACCESS_CONTROL_REQUEST_HEADERS" => "test"
      }

      options root_path, nil, headers
      expect(last_response.headers["Access-Control-Allow-Origin"]).to be_nil
      expect(last_response.headers["Access-Control-Allow-Methods"]).to be_nil
      expect(last_response.headers["Access-Control-Allow-Headers"]).to be_nil

      options job_offers_path(format: :json), nil, headers
      expect(last_response.headers["Access-Control-Allow-Origin"]).to eq("*")
      expect(last_response.headers["Access-Control-Allow-Methods"]).to eq("GET, OPTIONS")
      expect(last_response.headers["Access-Control-Allow-Headers"]).to eq("test")
    end
  end

  describe "POST /job_offers/:id/send_application" do
    subject(:post_request) { post send_application_job_offer_path(job_offer.slug), params: params, as: :turbo_stream }

    let(:job_offer) { create(:published_job_offer) }

    before do
      create(:department, :none)
      create(:department, name: "Any", code: "01")
      create(:foreign_language, name: "English")
      create(:foreign_language, name: "French")
      create(:foreign_language_level, name: "A1")
      create(:foreign_language_level, name: "A2")
      create(:job_application_file_type)
    end

    context "when the user is not signed in" do
      let(:params) do
        {
          job_application: {
            category_id: Category.first.id,
            user_attributes: {
              first_name: "Kambushka",
              last_name: "Warldorf",
              phone: "+33612345678",
              website_url: "https://linkedin.com/in/Warldorf",
              email: "k.warldorf@gmail.com",
              password: "Password1234!",
              password_confirmation: "Password1234!",
              terms_of_service: "1",
              certify_majority: "1",
              receive_job_offer_mails: "1",
              profile_attributes: {
                gender: "female",
                has_corporate_experience: "1",
                availability_range_id: AvailabilityRange.first.id,
                experience_level_id: ExperienceLevel.first.id,
                study_level_id: StudyLevel.first.id,
                profile_foreign_languages_attributes: {
                  "0" => {
                    foreign_language_id: ForeignLanguage.first.id,
                    foreign_language_level_id: ForeignLanguageLevel.first.id
                  },
                  "1" => {
                    foreign_language_id: ForeignLanguage.last.id,
                    foreign_language_level_id: ForeignLanguageLevel.last.id
                  }
                },
                category_experience_levels_attributes: {
                  "0" => {
                    category_id: Category.first.id,
                    experience_level_id: ExperienceLevel.first.id
                  }
                },
                department_profiles_attributes: {
                  "0" => {department_id: Department.first.id},
                  "1" => {department_id: Department.last.id}
                }
              }
            },
            job_application_files_attributes: {
              "0" => {
                job_application_file_type_id: JobApplicationFileType.first.id,
                content: fixture_file_upload("document.pdf", "application/pdf")
              }
            }
          }
        }
      end

      it { expect { post_request }.to change(User, :count).by(1) }

      it { expect { post_request }.to change(JobApplication, :count).by(1) }

      it { expect(post_request).to redirect_to(successful_job_offer_path(job_offer.slug)) }

      describe "created job application" do
        before { post_request }

        let(:job_application) { JobApplication.first }

        it { expect(job_application.category).to eq(Category.first) }

        it { expect(job_application.job_application_files.count).to eq(1) }
      end

      describe "created user" do
        before { post_request }

        let(:user) { User.first }

        it { expect(user.first_name).to eq("Kambushka") }

        it { expect(user.last_name).to eq("Warldorf") }

        it { expect(user.phone).to eq("+33612345678") }

        it { expect(user.website_url).to eq("https://linkedin.com/in/Warldorf") }

        it { expect(user.email).to eq("k.warldorf@gmail.com") }

        it { expect(user.organization).to eq(job_offer.organization) }
      end

      describe "created user profile" do
        before { post_request }

        let(:profile) { User.first.profile }

        it { expect(profile.gender).to eq("female") }

        it { expect(profile.has_corporate_experience).to be true }

        it { expect(profile.availability_range).to eq(AvailabilityRange.first) }

        it { expect(profile.experience_level).to eq(ExperienceLevel.first) }

        it { expect(profile.study_level).to eq(StudyLevel.first) }

        it { expect(profile.profile_foreign_languages.count).to eq(2) }

        it do
          expect(profile.profile_foreign_languages.pluck(:foreign_language_id)).to match(
            [ForeignLanguage.first.id, ForeignLanguage.last.id]
          )
        end

        it do
          expect(profile.profile_foreign_languages.pluck(:foreign_language_level_id)).to match(
            [ForeignLanguageLevel.first.id, ForeignLanguageLevel.last.id]
          )
        end

        it { expect(profile.category_experience_levels.count).to eq(1) }

        it { expect(profile.category_experience_levels.first.category_id).to eq(Category.first.id) }

        it { expect(profile.category_experience_levels.first.experience_level_id).to eq(ExperienceLevel.first.id) }

        it { expect(profile.departments.count).to eq(2) }

        it { expect(profile.departments.pluck(:id)).to match([Department.first.id, Department.last.id]) }
      end
    end

    context "when the user is signed in" do
      let(:user) { create(:confirmed_user) }
      let(:params) do
        {
          job_application: {
            category_id: Category.first.id,
            user_attributes: {
              first_name: "Kambushka",
              last_name: "Warldorf",
              phone: "+33612345678",
              website_url: "https://linkedin.com/in/Warldorf",
              profile_attributes: {
                gender: "female",
                has_corporate_experience: "1",
                availability_range_id: AvailabilityRange.first.id,
                experience_level_id: ExperienceLevel.first.id,
                study_level_id: StudyLevel.first.id,
                profile_foreign_languages_attributes: {
                  "0" => {
                    foreign_language_id: ForeignLanguage.first.id,
                    foreign_language_level_id: ForeignLanguageLevel.first.id
                  },
                  "1" => {
                    foreign_language_id: ForeignLanguage.last.id,
                    foreign_language_level_id: ForeignLanguageLevel.last.id
                  },
                  :category_experience_levels_attributes => {
                    "0" => {
                      category_id: Category.first.id,
                      experience_level_id: ExperienceLevel.first.id
                    }
                  }
                },
                department_profiles_attributes: {
                  "0" => {department_id: Department.first.id},
                  "1" => {department_id: Department.last.id}
                }
              }
            },
            job_application_files_attributes: {
              "0" => {
                job_application_file_type_id: JobApplicationFileType.first.id,
                content: fixture_file_upload("document.pdf", "application/pdf")
              }
            }
          }
        }
      end

      before { sign_in user }

      it { expect { post_request }.not_to change(User, :count) }

      it { expect { post_request }.to change(JobApplication, :count).by(1) }

      it { expect(post_request).to redirect_to(successful_job_offer_path(job_offer.slug)) }

      describe "created job application" do
        before { post_request }

        let(:job_application) { JobApplication.first }

        it { expect(job_application.category).to eq(Category.first) }

        it { expect(job_application.job_application_files.count).to eq(1) }
      end

      describe "updated user" do
        before { post_request }

        it { expect(user.reload.first_name).to eq("Kambushka") }

        it { expect(user.reload.last_name).to eq("Warldorf") }

        it { expect(user.reload.phone).to eq("+33612345678") }

        it { expect(user.reload.website_url).to eq("https://linkedin.com/in/Warldorf") }

        it { expect(user.reload.organization).to eq(job_offer.organization) }
      end

      describe "updated user profile" do
        before { post_request }

        let(:profile) { user.reload.profile }

        it { expect(profile.gender).to eq("female") }

        it { expect(profile.has_corporate_experience).to be true }

        it { expect(profile.availability_range).to eq(AvailabilityRange.first) }

        it { expect(profile.experience_level).to eq(ExperienceLevel.first) }

        it { expect(profile.study_level).to eq(StudyLevel.first) }

        it { expect(profile.profile_foreign_languages.count).to eq(2) }

        it do
          expect(profile.profile_foreign_languages.pluck(:foreign_language_id)).to match(
            [ForeignLanguage.first.id, ForeignLanguage.last.id]
          )
        end

        it do
          expect(profile.profile_foreign_languages.pluck(:foreign_language_level_id)).to match(
            [ForeignLanguageLevel.first.id, ForeignLanguageLevel.last.id]
          )
        end

        it { expect(profile.category_experience_levels.count).to eq(1) }

        it { expect(profile.category_experience_levels.first.category_id).to eq(Category.first.id) }

        it { expect(profile.category_experience_levels.first.experience_level_id).to eq(ExperienceLevel.first.id) }

        it { expect(profile.departments.count).to eq(2) }

        it { expect(profile.departments.pluck(:id)).to match([Department.first.id, Department.last.id]) }
      end
    end
  end
end
