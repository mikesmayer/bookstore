class CategoriesController < ApplicationController
  load_and_authorize_resource

  def index
    @categories = Category.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @category.save(category_params)
      redirect_to @category, notice: t("success.notices.create", resource: "Category")
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: t("success.notices.update", resource: "Category")
    else
      render :edit 
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: t("success.notices.destroy", resource: "Category")
  end

  private
  def category_params
    params.require(:category).permit(:category_name)
  end
end
