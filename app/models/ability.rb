# frozen_string_literal: true

# Cancancan ability definition
class Ability
  include CanCan::Ability

  def initialize(administrator)
    return unless administrator

    alias_action :archived, :stats, :board, :cvlm, :emails, :files, :export, :multi_select, :export, :send_job_offer, to: :read
    alias_action :listing, :update_listing, to: :read
    alias_action :suspend, to: :destroy

    can :read, JobOfferTerm
    can :read, SalaryRange
    can :read, EmailTemplate
    cannot :manage, PreferredUsersList

    if administrator.functional_administrator?
      ability_admin(administrator)
    elsif administrator.employment_authority?
      ability_employment_authority(administrator)
    elsif administrator.employer_recruiter?
      ability_employer_recruiter(administrator)
    else
      can :read, JobOffer, job_offer_actors: {administrator_id: administrator.id}
      can :read, JobApplication, job_application_read_query(administrator)
      cannot :validate_dar, JobApplication
      can :manage, JobApplication, brh_job_application_manage_query(administrator)
      can :manage, JobApplicationFile
      can :manage, Message
      can :manage, Email
    end
  end

  private

  def ability_admin(administrator)
    can :manage, :all
    can :manage, PreferredUsersList, administrator_id: administrator.id
    cannot :validate_dar, JobApplication
  end

  def ability_employment_authority(administrator)
    rules = JobApplicationActionRule.where(role: :employment_authority)

    can :read, JobOffer, job_offer_actors: {administrator_id: administrator.id}
    cannot :transfer, JobOffer, job_offer_actors: {administrator_id: administrator.id}
    can :read, User
    can :read, JobApplication, job_application_read_query(administrator)
    can :read, JobApplicationFile

    manage_state_rules = rules.where(manage_state: true)
    can :change_state, JobApplication do |ja|
      manage_state_rules.any? { |r| JobApplication.states[r.state] == JobApplication.states[ja.state] }
    end

    comment_states = rules.where(comment: true).pluck(:state)
    can :manage, Message do |message|
      comment_states.include?(message.job_application.state)
    end

    send_email_states = rules.where(send_email: true).pluck(:state)
    can :manage, Email do |email|
      send_email_states.include?(email.job_application.state)
    end

    validate_dar_states = rules.where(validate_dar: true).pluck(:state)
    can :validate_dar, JobApplication do |ja|
      validate_dar_states.include?(ja.state)
    end

    manage_file_states = rules.where(manage_file: true).pluck(:state)
    can :manage, JobApplicationFile do |file|
      manage_file_states.include?(file.job_application.state)
    end

    reject_states = rules.where(reject: true).pluck(:state)
    can :reject, JobApplication do |ja|
      reject_states.include?(ja.state)
    end

    manage_user_info_states = rules.where(manage_user_info: true).pluck(:state)
    can :manage_user_info, JobApplication do |ja|
      manage_user_info_states.include?(ja.state)
    end
  end

  def ability_employer_recruiter(administrator)
    can :create, JobOffer
    can :manage, JobOffer, job_offer_actors: {administrator_id: administrator.id}
    can :manage, JobOffer, owner_id: administrator.id
    cannot :transfer, JobOffer, job_offer_actors: {administrator_id: administrator.id}
    can :transfer, JobOffer, owner_id: administrator.id
    can :manage, JobApplication, job_application_read_query(administrator)
    cannot :validate_dar, JobApplication
    can :manage, JobApplicationFile
    can :manage, Message
    can :manage, Email
    can :update, User, employer_users_query(administrator)
    can :read, User
    can :manage, PreferredUsersList, administrator_id: administrator.id
  end

  def job_application_read_query(administrator)
    {
      job_offer: {
        job_offer_actors: {
          administrator_id: administrator.id
        }
      }
    }
  end

  def employer_users_query(administrator)
    {
      job_offers: {
        job_offer_actors: {
          administrator_id: administrator.id
        }
      }
    }
  end

  def brh_job_application_manage_query(administrator)
    role_brh = JobOfferActor.roles[:brh]
    role_cmg = JobOfferActor.roles[:cmg]
    {
      job_offer: {
        job_offer_actors: {
          administrator_id: administrator.id,
          role: [role_brh, role_cmg]
        }
      }
    }
  end
end
