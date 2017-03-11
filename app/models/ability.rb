class Ability
  include CanCan::Ability

  def initialize(user)
    can [:edit, :update, :destroy], Activity,  creator: user
    can :destroy, Participation, participant: user
    can :destroy, Authentication, user: user
  end
end
