class AmisController < CmsController
  def schema
    @resource = params[:resource]
    @id = params[:id]
    @type = params[:type]
    if @id
      @object = @resource.classify.constantize.with_deleted.find @id
    end

    case @type
    when 'edit', 'view', 'create'
      render "amis/#{@resource}/form_schema"
    when 'list'
      render "amis/#{@resource}/list_schema"
    else
      render "amis/#{@resource}/#{@type}_schema"
    end
  end
end
