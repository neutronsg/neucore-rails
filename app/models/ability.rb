# frozen_string_literal: true
# permission: company:read:all, read all companies: can :read, Company
# permission: user:read:Company, read users which have the same company: can :read, User, company_id: user.company_id
# permission: community_post:read:Company, read community_posts which the author's company_id have the same company: 
#   can :read, CommunityPost, user: {company_id: user.company_id}
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

        can(:create, model) and next if action == :create

        if scope == 'ALL'
          can action, model
        else
          foreign_key = scope.foreign_key
          next unless defined?(scope.classify.constantize)
          next unless user.respond_to?(foreign_key) && user.send(foreign_key).present?

          # can :read, Company, id: user.company_id
          if model.name == scope
            can action, model, id: user.send(foreign_key)
          end

          # can :read, User, company_id: user.company_id
          if model.attribute_names.include?(foreign_key)
            can action, model, foreign_key => user.send(foreign_key)
          end

          # can :read, CommunityPost, user: {company_id: user.company_id}
          # can :read, Comment, user: {company_id: user.company_id}
          # can :read, CommentReport, user: {company_id: user.company_id}
          # can :read, SearchHistory, user: {company_id: user.company_id}
          if model.attribute_names.include?('user_id')
            can action, model, user: {foreign_key => user.send(foreign_key)}
          end

          if model.name != scope && !model.attribute_names.include?(foreign_key) && !model.attribute_names.include?('user_id')
            can action, model
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





