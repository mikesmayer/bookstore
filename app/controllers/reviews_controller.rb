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
    @review = current_user.review.new(review_params)
    if @review.save
      redirect_to book_path(Book.find(@review.book_id)), notice: 'Review was successfully created.'
    else
      flash[:errors] = @review.errors
      redirect_to :back
    end
  end

  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_status
    if @review.update(review_params)
      redirect_to :back, notice: 'Review was successfully updated.'
    else
      redirect_to :back
    end
  end

  private
 
  def review_params
    params.require(:review).permit(:book_id, :rating, :text, :approved)
  end
end
