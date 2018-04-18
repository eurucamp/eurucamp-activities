# frozen_string_literal: true

class ActivityPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def edit?
    activity.creator == user
  end

  def update?
    edit?
  end

  def destroy?
    activity.creator == user
  end

  alias activity record
end
