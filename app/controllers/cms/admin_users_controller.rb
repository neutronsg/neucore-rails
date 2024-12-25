class Cms::AdminUsersController < CmsController
  jwt_token_auth ['admin_user']
  skip_before_action :token_authenticate_admin_user!, only: [:sign_in]
  before_action :authorize_index!, only: :index
  
  def index
    q = params.permit(:name_cont, :email_cont)
    objects = AdminUser.all
    if params[:scope] && AdminUser.respond_to?(params[:scope])
      objects = objects.public_send(params[:scope])
    end

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
    params.permit(:name, :email, :super_admin, :password, admin_role_ids: [])
  end

  def update_params
    params.permit(:name, :email, :super_admin, admin_role_ids: [])
  end
end
