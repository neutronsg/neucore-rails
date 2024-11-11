class Amis::AdminRoleScopesController < CmsController
  before_action :load_object, only: [:show, :update]
  before_action :authorize_index!, only: :index
  
  def index
    q = params.permit(:name_cont)
    objects = AdminRoleScope.all
    if params[:scope] && AdminRoleScope.respond_to?(params[:scope])
      objects = objects.public_send(params[:scope])
    end

    @unscoped_objects = AdminRoleScope.ransack(q).result(distinct: true)
    @objects = objects.ransack(q).result(distinct: true).order(default_order).page(page).per(per_page)
  end

  private
  def create_params
    params.permit(:name, :scope, scope_ids: [])
  end

  def update_params
    params.permit(:name, :scope, scope_ids: [])
  end
end
