class ApiController < NeucoreController
  allow_browser versions: :modern
  before_action :set_default_format
  skip_before_action :verify_authenticity_token

  layout 'api'

  private
  def set_default_format
    request.format = :json
  end
end
