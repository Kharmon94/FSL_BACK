# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    if user.admin?
      can :manage, :all
    else
      # Scoped abilities for non-admins
      # can :read, SomeResource
    end
  end
end
