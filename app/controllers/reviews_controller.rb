class ReviewsController < ApplicationController
  before_action :authenticate_user!
  def new
    @review = Review.new
  end

  def create
    review = Review.new(review_params)
    spot = Spot.find(params[:spot_id])
    review.spot = spot
    review.user = current_user
    review.save
    redirect_to stored_location_for(:user)
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to stored_location_for(:user)
  end

  private

  def review_params
    params.require(:review).permit(:title, :description, :rating)
  end
end
