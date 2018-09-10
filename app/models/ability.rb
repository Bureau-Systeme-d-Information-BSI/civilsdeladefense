class Ability
  include CanCan::Ability

  def initialize(administrator)
    if administrator
      case administrator.role
      when 'bant'
        can :manage, :all
      when 'employer'
        can :manage, JobOffer, employer_id: administrator.employer_id
        can :manage, Administrator, employer_id: administrator.employer_id
      when 'brh'
        can :read, JobOffer, employer_id: administrator.employer_id
      end
    end
  end
end
