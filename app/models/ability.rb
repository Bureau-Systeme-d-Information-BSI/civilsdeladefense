class Ability
  include CanCan::Ability

  def initialize(administrator)
    if administrator
      case administrator.role
      when 'bant'
        can :manage, :all
      when 'employer'
        can :manage, JobOffer, employer_id: administrator.employer_id
        can :manage, JobApplication, employer_id: administrator.employer_id
        can :manage, Message
        can :manage, Email
        can :manage, Administrator, employer_id: administrator.employer_id
      when 'brh'
        can :read, JobOffer, employer_id: administrator.employer_id
        can :read, JobApplication, employer_id: administrator.employer_id
        can :read, Message
        can :read, Email
        can :manage, Administrator, employer_id: administrator.employer_id, role: 'brh'
      end
    end
  end
end
