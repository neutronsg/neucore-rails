# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= AdminUser.new
    if user.super_admin?
      can :manage, :all
    else
      permissions = user.permissions

      permissions.each do |permission|
        model, action, scope = permission.split(":")
        model = model.classify.constantize
        action = action.to_sym

        if scope == 'ALL'
          can action, model
        else
          foreign_key = scope.foreign_key

          if defined?(scope) && model.name == scope && user.respond_to?(foreign_key) && user.send(foreign_key).present?
            can action, model, id: user.send(foreign_key)
          end

          if defined?(scope) && model.attribute_names.include?(foreign_key) && user.respond_to?(foreign_key) && user.send(foreign_key).present?
            can action, model, foreign_key => user.send(foreign_key)
          end
        end
      end
    end
  end

  private

  def get_permissions actions = []
    actions.map!(&:to_sym)
    if actions.include?(:read) && actions.include?(:write)
      return [:manage]
    end

    result = []
    result << :read if actions.include?(:read)
    result += [:create, :update, :destroy] if actions.include?(:write)

    result << :create if actions.include?(:create)
    result << :update if actions.include?(:update)
    result << :destroy if actions.include?(:destroy)

    custom_actions = actions - default_actions
    result += custom_actions.map(&:to_sym) if custom_actions.present?
    result.uniq!
    result
  end

  def default_actions
    %i(read write create update destroy)
  end
end





