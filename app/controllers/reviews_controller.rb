class ReviewsController < ApplicationController
  load_and_authorize_resource

  def index
    @reviews = Review.accessible_by(current_ability).all
  end

  def show
  end

  def new
    redirect_to new_user_session_path, notice: 'You should log in for creating review' unless current_user
    @review = Review.new
    @review.book_id = params[:book_id]
  end

  def edit
  end

  def create

    @review = current_user.review.new(review_params) if current_user

    respond_to do |format|

      if @review.save
        format.html { redirect_to @review, notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
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
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end


  private
    def set_review
      @review = Review.find(params[:id])
    end

   
    def review_params
      params.require(:review).permit(:book_id, :rating, :text, :approved)
    end
end
