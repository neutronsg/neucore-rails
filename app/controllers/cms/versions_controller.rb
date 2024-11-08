class Cms::VersionsController < CmsController  
  def index
    item_type = params[:item_type]
    item_id = params[:item_id]
    @resource = item_type.classify.constantize.with_deleted.find_by(id: item_id)
    @versions = @resource&.try(:related_versions)&.limit(200) || @resource&.versions.includes(:item)&.reorder(created_at: :desc)&.limit(200)
  end
end
