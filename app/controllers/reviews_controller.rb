class ReviewsController < ApplicationController
  load_and_authorize_resource

  def index
    @reviews = Review.accessible_by(current_ability).all
  end

  def show
  end

  def edit
  end

  def create
    if @review.save(review_params)
      redirect_to book_path(Book.find(@review.book_id)), notice: t("success.notices.create", resource: "Review")
    else
      flash[:errors] = @review.errors
      redirect_to :back
    end
  end

  def update
    if @review.update(review_params)
      redirect_to reviews_path, notice: t("success.notices.update", resource: "Review")
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to reviews_url,    notice: t("success.notices.destroy", resource: "Review")
  end

  def update_status
    if @review.update(review_params)
      redirect_to :back,        notice: t("success.notices.update", resource: "Review")
    else
      redirect_to :back
    end
  end

  private
 
  def review_params
    params.require(:review).permit(:book_id, :rating, :text, :approved)
  end
end
