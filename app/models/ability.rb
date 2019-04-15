class Ability
  include CanCan::Ability

  def initialize(administrator)
    if administrator
      can :read, SalaryRange
      case administrator.role
      when 'bant'
        can :manage, :all
      when 'employer'
        can :create, JobOffer
        can :manage, JobOffer, job_offer_actors: {administrator_id: administrator.id}
        can :manage, JobApplication, job_offer: {job_offer_actors: {administrator_id: administrator.id}}
        can :manage, JobApplicationFile
        can :manage, Message
        can :manage, Email
      else
        can :read, JobOffer, job_offer_actors: {administrator_id: administrator.id}
        can :read, JobApplication, job_offer: {job_offer_actors: {administrator_id: administrator.id}}
        role_brh_enum = JobOfferActor.roles[:brh]
        can :manage, JobApplication, job_offer: {job_offer_actors: {administrator_id: administrator.id, role: role_brh_enum}}
        can :manage, JobApplicationFile
        can :read, Message
        can :read, Email
      end
    end
  end
end
