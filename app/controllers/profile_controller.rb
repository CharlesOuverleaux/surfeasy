class ProfileController < ApplicationController
  def index
    # redirect to root if not logged in
    redirect_to root_path unless current_user
    @user = current_user
  end
end
