class Cms::AdminRolesController < CmsController
  before_action :authorize_index!, only: :index
  
  def index
    q = params.permit(:name_cont)
    objects = AdminRole.all
    if params[:scope] && AdminRole.respond_to?(params[:scope])
      objects = objects.public_send(params[:scope])
    end

    @objects = objects.ransack(q).result(distinct: true).order(default_order).page(page).per(per_page)
  end

  private
  def create_params
    params.permit(:name, admin_role_scope_ids: [], permissions: AdminRole.load_permissions.keys.collect{|k| {k => []}})
  end

  def update_params
    params.permit(:name, admin_role_scope_ids: [], permissions: AdminRole.load_permissions.keys.collect{|k| {k => []}})
  end
end
