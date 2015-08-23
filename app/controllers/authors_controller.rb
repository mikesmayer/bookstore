class AuthorsController < ApplicationController
  load_and_authorize_resource

  def index
    @authors = Author.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @author.save(author_params)
      redirect_to @author, notice: t("success.notices.create", resource: "Author")
    else
      render :new
    end
  end

  def update
    if @author.update(author_params)
      redirect_to @author, notice: t("success.notices.update", resource: "Author")
    else
      render :edit 
    end
  end

  def destroy
    @author.destroy
    redirect_to authors_url, notice: t("success.notices.destroy", resource: "Author")
  end

  private

  def author_params
    params.require(:author).permit(:first_name, :last_name, :biography, :filterrific)
  end
end
