# frozen_string_literal: true

class ParticipationPolicy < ApplicationPolicy
  def show?
    participation.participant == user
  end

  def destroy?
    participation.participant == user
  end

  alias participation record
end
