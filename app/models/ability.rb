# frozen_string_literal: true

# Cancancan ability definition
class Ability
  include CanCan::Ability

  def initialize(administrator)
    return unless administrator

    can :read, SalaryRange
    case administrator.role
    when 'bant'
      can :manage, :all
    when 'employer'
      can :create, JobOffer
      can :manage, JobOffer, job_offer_actors: { administrator_id: administrator.id }
      can :manage, JobApplication, employer_job_application_query
      can :manage, JobApplicationFile
      can :manage, Message
      can :manage, Email
    else
      can :read, JobOffer, job_offer_actors: { administrator_id: administrator.id }
      can :read, JobApplication, job_application_read_query
      can :manage, JobApplication, brh_job_application_manage_query
      can :manage, JobApplicationFile
      can :read, Message
      can :read, Email
    end
  end

  private

  def employer_job_application_query
    {
      job_offer: {
        job_offer_actors: {
          administrator_id: administrator.id
        }
      }
    }
  end

  def job_application_read_query
    {
      job_offer: {
        job_offer_actors: {
          administrator_id: administrator.id
        }
      }
    }
  end

  def brh_job_application_manage_query
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
