# frozen_string_literal: true

class AuthenticationPolicy < ApplicationPolicy
  def show?
    authentication.user == user
  end

  def destroy?
    authentication.user == user
  end

  alias authentication record
end
