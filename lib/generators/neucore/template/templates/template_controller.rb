class Amis::<%= resource.pluralize %>Controller < AmisController
  before_action :authorize_index!, only: :index
  
  def index
    q = params.permit(:name_cont)
    objects = <%= resource.classify %>.accessible_by(current_ability)
    if params[:scope] && <%= resource.classify %>.respond_to?(params[:scope])
      objects = objects.public_send(params[:scope])
    end

    @unscoped_objects = <%= resource.classify %>.ransack(q).result(distinct: true)
    @objects = objects.ransack(q).result(distinct: true).order(default_order).page(page).per(per_page)
  end

  private
  def create_params
    params.permit(:name)
  end

  def update_params
    params.permit(:name)
  end
end
