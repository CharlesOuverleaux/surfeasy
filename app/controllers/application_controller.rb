class ApplicationController < ActionController::Base
  before_action :check_page
  before_action :store_user_location!, if: :storable_location?

  private

  def check_page
    @con = controller_name
    @action = action_name

    # not show header on landing
    @header_show = true
    @header_show = false if @con == 'pages' && @action == 'home'

    # show interaction icons on spots show
    @header_share_show = false
    @header_share_show = true if @con == 'spots' && @action == 'show'
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end
end
