class ReviewsController < ApplicationController
  def create
    @review = Review.new(review_params)
    # we need `restaurant_id` to associate review with corresponding restaurant
    @spot = Spot.find(params[:spot_id])
    # @spot.restaurant = @restaurant
    @spot.save
    # redirect_to restaurant_path(@restaurant)
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to spot_path(@review.spot_id)
  end

  private

  def review_params
    # missing description and rating
    params.require(:review).permit(:title)
  end
end
