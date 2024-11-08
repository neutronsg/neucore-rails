class Cms::FormsController < CmsController
  def form_ui
    @resource = params.delete(:resource)
    @action_name = params[:action_name] || (params[:id].present? ? 'update' : 'create')
    @parent_resource = params[:parent_resource].classify.constantize.find(params[:parent_resource_id]) if params[:parent_resource] && params[:parent_resource_id]
    @object = @resource.classify.constantize.find params[:id] if params[:id].present?
  end

  def simple_list
    resource = params.delete(:resource)
    per_page = params.delete(:per_page) || 200
    q = params.permit!.to_h
    @objects = resource.classify.constantize.ransack(q).result.page(1).per(per_page)
    if File.exist?("#{Rails.root}/app/views/cms/#{resource}/_simple_list.json.jbuilder")
      render "/cms/#{resource}/_simple_list"
    else
      render :simple_list
    end
  end
end
