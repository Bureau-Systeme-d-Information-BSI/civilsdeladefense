# frozen_string_literal: true

# Cancancan ability definition
class Ability
  include CanCan::Ability

  def initialize(administrator)
    return unless administrator

    alias_action :archived, :stats, :board, :cvlm, to: :read
    alias_action :listing, :update_listing, to: :read
    alias_action :suspend, to: :destroy

    can :read, SalaryRange
    can :read, EmailTemplate
    cannot :manage, PreferredUsersList
    case administrator.role
    when 'bant'
      ability_bant(administrator)
    when 'employer'
      ability_employer(administrator)
    else
      can :read, JobOffer, job_offer_actors: { administrator_id: administrator.id }
      can :read, JobApplication, job_application_read_query(administrator)
      can :manage, JobApplication, brh_job_application_manage_query(administrator)
      can :manage, JobApplicationFile
      can :manage, Message
      can :manage, Email
    end
  end

  private

  def ability_bant(administrator)
    can :manage, :all
    can :manage, PreferredUsersList, administrator_id: administrator.id
  end

  def ability_employer(administrator)
    can :create, JobOffer
    can :manage, JobOffer, job_offer_actors: { administrator_id: administrator.id }
    can :manage, JobOffer, owner_id: administrator.id
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
    role_brh_enum = JobOfferActor.roles[:brh]
    {
      job_offer: {
        job_offer_actors: {
          administrator_id: administrator.id,
          role: role_brh_enum
        }
      }
    }
  end
end
