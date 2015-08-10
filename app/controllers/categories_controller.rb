class CategoriesController < ApplicationController
  load_and_authorize_resource

  def index
    @categories = Category.all
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to @category, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: 'Category was successfully updated.'
    else
      flash.now[:error] = 'Could not save category.'
      render :edit 
    end
  end

  def destroy
    @category.destroy
      redirect_to categories_url, notice: 'Category was successfully destroyed.'
    end
  end

  private
  def category_params
    params.require(:category).permit(:category_name)
  end
end
