# frozen_string_literal: true

# Cancancan ability definition
class Ability
  include CanCan::Ability

  def initialize(administrator)
    return unless administrator

    alias_action :archived, :stats, :board, :cvlm, :export, :multi_select, :export, :send_job_offer, to: :read
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
  end

  def ability_employment_authority(administrator)
    can :read, JobOffer, job_offer_actors: {administrator_id: administrator.id}
    cannot :transfer, JobOffer, job_offer_actors: {administrator_id: administrator.id}
    can :read, JobApplication, job_application_read_query(administrator)
    can :read, JobApplicationFile
    can :read, Message
    can :read, Email
    can :read, User
  end

  def ability_employer_recruiter(administrator)
    can :create, JobOffer
    can :manage, JobOffer, job_offer_actors: {administrator_id: administrator.id}
    can :manage, JobOffer, owner_id: administrator.id
    cannot :transfer, JobOffer, job_offer_actors: {administrator_id: administrator.id}
    can :transfer, JobOffer, owner_id: administrator.id
    can :manage, JobApplication, job_application_read_query(administrator)
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
