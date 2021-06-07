class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_page

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
end
