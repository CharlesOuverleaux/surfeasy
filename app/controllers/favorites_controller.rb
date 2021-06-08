class FavoritesController < ApplicationController
  def new
    @favorite = Favorite.new
  end

  def create
    favorite = Favorite.new
    spot = Spot.find(params[:spot_id])
    favorite.spot = spot
    favorite.user = current_user
    favorite.save
    redirect_to spot_path(spot)
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    redirect_to spot_path(@favorite.spot_id)
  end
end
