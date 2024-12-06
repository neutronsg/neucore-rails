class CmsController < NeucoreController
  include Neucore::JwtTokenAuthenticator
  before_action :set_default_format
  skip_before_action :verify_authenticity_token

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
          if @resource == 'community_posts'
            render "cms/#{@resource}/form_schema"
          else
            render "cms/#{@resource}/form_schema"
          end
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
      if @object.save
        save_images
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
        update_images
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
  def save_images
    if params[:images].present? && @object.respond_to?(:images)
      params[:images].each_with_index do |image_attr, index|
        image = Image.find image_attr[:value]
        image.update(
          target: @object, 
          name: image_attr[:name], 
          width: image_attr.dig(:info, :width), 
          height: image_attr.dig(:info, :height), 
          media_type: 'image',
          ranking: index + 1
        )
      end
    end

    if params[:videos].present? && @object.respond_to?(:images)
      params[:videos].each_with_index do |image_attr, index|
        image = Image.find image_attr[:value]
        image.update(
          target: @object, 
          name: image_attr[:name],
          media_type: 'video',
          ranking: index + 1
        )
      end
    end
  end

  def update_images
    if params[:images].present? && @object.respond_to?(:images)
      params[:images].each_with_index do |image_attr, index|
        image = Image.find image_attr[:value]
        image.update(
          target: @object, 
          name: image_attr[:name],
          width: image_attr.dig(:info, :width), 
          height: image_attr.dig(:info, :height), 
          media_type: 'image',
          ranking: index + 1
        )
      end

      @object.images.image.where.not(id: params[:images].pluck(:value)).update_all target_type: nil, target_id: nil
    elsif params[:images]&.empty?
      @object.images.image.update_all target_type: nil, target_id: nil
    end

    if params[:videos].present? && @object.respond_to?(:images)
      # @object.images.video.update_all target_type: nil, target_id: nil
      params[:videos].each_with_index do |image_attr, index|
        image = Image.find image_attr[:value]
        image.update(
          target: @object, 
          name: image_attr[:name],
          media_type: 'video',
          ranking: index + 1
        )
      end

      @object.images.video.where.not(id: params[:videos].pluck(:value)).update_all target_type: nil, target_id: nil

    elsif params[:videos]&.empty?
      @object.images.video.update_all target_type: nil, target_id: nil
    end
  end

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
