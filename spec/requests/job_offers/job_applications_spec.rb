# frozen_string_literal: true

require "rails_helper"

RSpec.describe "JobOffers::JobApplications" do
  describe "GET /offresdemploi/:job_offer_id/candidature/new" do
    subject(:get_request) { get new_job_offer_job_application_path(job_offer) }

    let(:job_offer) { create(:published_job_offer) }

    context "when fetching a specific job offer application page" do
      before { get_request }

      it { expect(response).to have_http_status(:ok) }
    end

    context "when the user already has a previous job application" do
      let(:user) { create(:confirmed_user) }

      before do
        create(:job_application, user:)
        sign_in user
        get_request
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe "POST /offresdemploi/:job_offer_id/candidature" do
    subject(:post_request) { post job_offer_job_application_path(job_offer), params: params, as: :turbo_stream }

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
                resume: fixture_file_upload("document.pdf", "application/pdf"),
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

      it { expect(post_request).to redirect_to(job_offer_job_application_path(job_offer)) }

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

        it { expect(profile.resume).to be_present }
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
                resume: fixture_file_upload("document.pdf", "application/pdf"),
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

      before do
        user.profile.departments = [Department.first, Department.last]
        sign_in user
      end

      it { expect { post_request }.not_to change(User, :count) }

      it { expect { post_request }.to change(JobApplication, :count).by(1) }

      it { expect(post_request).to redirect_to(job_offer_job_application_path(job_offer)) }

      it { expect { post_request }.not_to change { user.reload.profile } }

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

        it { expect(profile.resume).to be_present }
      end
    end
  end

  describe "POST /offresdemploi/:job_offer_id/candidature when the application is invalid" do
    let(:job_offer) { create(:published_job_offer) }
    let(:params) do
      {
        job_application: {
          category_id: Category.first.id,
          user_attributes: {
            first_name: "Kambushka",
            last_name: "Warldorf",
            email: "not-an-email",
            password: "Password1234!",
            password_confirmation: "different",
            terms_of_service: "1",
            certify_majority: "1",
            profile_attributes: {gender: "female"}
          }
        }
      }
    end

    before { create(:job_application_file_type) }

    context "when format is turbo_stream" do
      subject(:post_request) { post job_offer_job_application_path(job_offer), params:, as: :turbo_stream }

      it { post_request and expect(response).to have_http_status(:ok) }

      it { expect { post_request }.not_to change(JobApplication, :count) }
    end

    context "when format is html" do
      subject(:post_request) { post job_offer_job_application_path(job_offer), params: }

      before { post_request }

      it { expect(response).to render_template(:new) }
    end

    context "when format is json" do
      subject(:post_request) { post job_offer_job_application_path(job_offer, format: :json), params: }

      before { post_request }

      it { expect(response).to have_http_status(:unprocessable_content) }
    end
  end

  describe "POST /offresdemploi/:job_offer_id/candidature as json when the application is valid" do
    subject(:post_request) { post job_offer_job_application_path(job_offer, format: :json), params: }

    let(:job_offer) { create(:published_job_offer) }
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
              resume: fixture_file_upload("document.pdf", "application/pdf"),
              category_experience_levels_attributes: {
                "0" => {
                  category_id: Category.first.id,
                  experience_level_id: ExperienceLevel.first.id
                }
              },
              department_profiles_attributes: {"0" => {department_id: Department.last.id}}
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

    before do
      create(:department, :none)
      create(:department, name: "Any", code: "01")
      create(:job_application_file_type)
      post_request
    end

    it { expect(response).to have_http_status(:created) }
  end
end
