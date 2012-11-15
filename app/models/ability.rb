class Ability
  include CanCan::Ability

  def initialize(user)
    # TODO
    can :manage, :all

    can :read, Area
    can :read, Waypoint, is_private: false
    can :read, Route, is_private: false
    can :read, RouteElement, route: {is_private: false}

    if user
      can :manage, Waypoint, user_id: user.id
      can :manage, Route, user_id: user.id
      can :manage, RouteElement, route: {user_id: user.id}
    end

    if user and user.admin
      can :manage, Area
      can :manage, Waypoint
      can :manage, Route
      can :manage, RouteElement

      can :manage, User
      can :manage, Importer
    end

    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
