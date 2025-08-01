class Cms::AdminRoleScopesController < CmsController
  before_action :authorize_index!, only: :index
  
  def index
    q = params.permit(:name_cont)
    objects = AdminRoleScope.all
    if params[:scope] && AdminRoleScope.respond_to?(params[:scope])
      objects = objects.public_send(params[:scope])
    end

    @objects = objects.ransack(q).result(distinct: true).order(custom_order).page(page).per(per_page)
  end

  private
  def create_params
    params.permit(:name, :scope, scope_ids: [])
  end

  def update_params
    params.permit(:name, :scope, scope_ids: [])
  end
end
