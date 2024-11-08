class ApplicationController < NeucoreController
  layout 'application'
  helper_method :current_admin_user, :human_enum
end
