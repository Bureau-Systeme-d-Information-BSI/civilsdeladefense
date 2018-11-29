class Ability
  include CanCan::Ability

  def initialize(administrator)
    if administrator
      can :read, SalaryRange
      case administrator.role
      when 'bant'
        can :manage, :all
      when 'employer'
        employer_id = administrator.employer_id
        can :manage, JobOffer, employer_id: employer_id
        can :manage, JobApplication, employer_id: employer_id
        can :manage, Message
        can :manage, Email
        can :manage, Administrator, employer_id: employer_id
      when 'brh'
        employer_id = administrator.employer_id
        can :read, JobOffer, employer_id: employer_id
        can :read, JobApplication, employer_id: employer_id
        can :read, Message
        can :read, Email
        can :create, Administrator
        can :manage, Administrator, employer_id: employer_id, role: 'brh'
      when 'grand_employer'
        employer_ids = administrator.employer.children.map(&:id) << administrator.employer_id
        can :read, JobOffer, employer_id: employer_ids
        can :read, JobApplication, employer_id: employer_ids
        can :read, Message
        can :read, Email
        can :create, Administrator
        can :read, Administrator, employer_id: employer_ids
      end
    end
  end
end
