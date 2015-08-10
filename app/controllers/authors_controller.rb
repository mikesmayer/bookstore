class AuthorsController < ApplicationController
  load_and_authorize_resource

  def index
    @authors = Author.all
  end

  def show
  end

  def new
    @author = Author.new
  end

  def edit
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      redirect_to @author, notice: 'Author was successfully created.'
    else
      render :new
    end
  end

  def update
    if @author.update(author_params)
      redirect_to @author, notice: 'Author was successfully updated.'
    else
      flash.now[:error] = 'Could not save author.'
      render :edit 
    end
  end

  def destroy
    @author.destroy
    redirect_to authors_url, notice: 'Author was successfully destroyed.'
  end

  private

  def author_params
    params.require(:author).permit(:first_name, :last_name, :biography, :filterrific)
  end
end
