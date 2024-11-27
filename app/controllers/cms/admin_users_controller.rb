class Cms::AdminUsersController < CmsController
  skip_before_action :token_authenticate_admin_user!, only: [:sign_in]
  before_action :authorize_index!, only: :index
  
  def index
    q = params.permit(:name_cont, :email_cont)
    objects = AdminUser.all
    if params[:scope] && AdminUser.respond_to?(params[:scope])
      objects = objects.public_send(params[:scope])
    end

    @unscoped_objects = AdminUser.ransack(q).result(distinct: true)
    @objects = objects.ransack(q).result(distinct: true).order(default_order).page(page).per(per_page)
  end
  
  def reset_password
    authorize! :update, current_admin_user
    
    if params[:password] && params[:password_confirmation] && params[:password] == params[:password_confirmation]
      current_admin_user.update! password: params[:password]
      operation_success
    else
      operation_failed(I18n.t('errors.password_does_not_match'))
    end
  end

  def sign_in
    password, email = params[:password], params[:email]
    @object = AdminUser.find_by_email email
    unauthorized and return if @object.nil?

    if @object.valid_password?(password)
      @object.generate_and_set_jwt_token
    else
      unauthorized
    end
  end

  private
  def create_params
    fields = %i(name email password super_admin)
    if params[:super_admin]
      params.permit(*fields)
    else
      fields += AdminRoleScope.scopes(AdminUser)
      params.permit(*fields).merge(admin_role_ids: params[:admin_role_id])
    end
  end

  def update_params
    fields = %i(name email) + AdminRoleScope.scopes(AdminUser)
    params.permit(*fields).merge(admin_role_ids: params[:admin_role_id])
  end
end
