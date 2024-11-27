class CmsController < NeucoreController
  before_action :set_default_format
  skip_before_action :verify_authenticity_token
  include Neucore::JwtTokenAuthenticator

  before_action :token_authenticate_admin_user!
  before_action :set_current_ability
  before_action :set_paper_trail_whodunnit
  before_action :load_object, only: [:show, :update, :destroy, :edit]

  jwt_token_auth ['admin_user']
  layout 'cms'

  def schema
    @resource = params[:resource]
    @id = params[:id]
    @type = params[:type]
    if @id
      @object = @resource.classify.constantize.with_deleted.find @id
    end

    case @type
    when 'edit', 'view', 'create'
      if @type == 'view' && File.exist?("#{Rails.root}/app/views/cms/#{@resource}/view_schema.json.jbuilder")
        render "cms/#{@resource}/view_schema"
      else
        if %w(examples1 examples2 examples3 examples4).include?(@resource)
          render "cms/examples/#{@resource}"
        else
          render "cms/#{@resource}/form_schema"
        end
      end
    when 'list'
      render "cms/#{@resource}/list_schema"
    else
      render "cms/#{@resource}/#{@type}_schema"
    end
  end

  def create
    authorize! :create, controller_name.classify.constantize
    ActiveRecord::Base.transaction do
      @object = controller_name.classify.constantize.new create_params
      if @object.save!
        if params[:images].present? && @object.respond_to?(:images)
          params[:images].each_with_index do |image_attr, index|
            image = Image.find image_attr[:id]
            image.update target: @object, ranking: 100 - index
          end
        end
        operation_success(id: @object.id)
      else
        operation_failed(@object.errors.full_messages.join(","))
      end
    end
  end

  def update
    authorize! :update, @object
    ActiveRecord::Base.transaction do
      if @object.update update_params
        if params[:images].present? && @object.respond_to?(:images)
          @object.images.update_all target_type: nil, target_id: nil
          params[:images].each_with_index do |image_attr, index|
            image = Image.find image_attr[:id]
            image.update target: @object, ranking: 100 - index
          end
        elsif params[:images]&.empty?
          @object.images.update_all target_type: nil, target_id: nil
        end

        operation_success(id: @object.id)
      else
        operation_failed(@object.errors.full_messages.join(","))
      end
    end
  end

  def edit
    authorize! :update, @object
  end

  def show
    authorize! :read, @object
  end

  def destroy
    authorize! :destroy, @object

    @object.check_dependence_destroy!
    operation_success
  end

  private
  def set_default_format
    request.format = :json
  end

  def set_current_ability
    # tc = AdminUser.find 1
    @current_ability ||= ::Ability.new(current_admin_user)
  end
  
  def load_object
    @object = controller_name.classify.constantize.with_deleted.find params[:id]
  end

  def load_objects
    @objects = controller_name.classify.constantize.with_deleted.where(id: params[:ids])
  end

  def user_for_paper_trail
    return nil unless current_admin_user.present?
    "0#{current_admin_user.name}(#{current_admin_user.id})"
  end

  def authorize_index!
    authorize! :read, controller_name.classify.constantize
  end

  def operation_success message = nil, **options
    render json: { request_id: request.uuid, status: 0, msg: message || I18n.t('operation_success'), data: options}
  end

  def operation_failed message = nil, **options
    render json: { request_id: request.uuid, status: 1, msg: message || I18n.t('operation_failed'), data: options}
  end

  def render_errors(errors, status = :unprocessable_entity)
    errors = [errors] unless errors.is_a?(Array)
    sentry_messages = []
    errors.each do |error|
      error[:message] = I18n.t("errors.#{error[:code]}", default: error[:code].titleize) unless error[:message].present?
      sentry_messages << error[:message].to_s
    end
    Sentry.capture_message(sentry_messages.join(","))
    render json: {request_id: request.uuid, status: 1, msg: sentry_messages.join(",") || I18n.t('operation_failed')}
  end
end
