class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Area
    can [:read, :sunrise_sunset], Waypoint, is_private: false
    can :read, Route, is_private: false
    can :read, RouteElement, route: {is_private: false}

    if user
      can :manage, Waypoint, user_id: user.id
      can :manage, Route, user_id: user.id
      can :manage, RouteElement, route: {user_id: user.id}

      can :draw_normal_big_map, Route
    end

    if user and user.admin
      can :manage, Area
      can :manage, Waypoint
      can :manage, Route
      can :manage, RouteElement

      can :manage, User
      can :manage, Importer

      can :draw_super_big_map, Route
    end

    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
