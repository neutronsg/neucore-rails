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
      if @type == 'view' && File.exist?("#{Rails.root}/app/views/amis/#{@resource}/view_schema.json.jbuilder")
        render "amis/#{@resource}/view_schema"
      else
        if %w(examples1 examples2 examples3).include?(@resource)
          render "amis/examples/#{@resource}"
        else
          render "amis/#{@resource}/form_schema"
        end
      end
    when 'list'
      render "amis/#{@resource}/list_schema"
    else
      render "amis/#{@resource}/#{@type}_schema"
    end
  end
end
