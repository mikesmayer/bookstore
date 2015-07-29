module FilterrificStuff

  extend ActiveSupport::Concern

  def filterrific_books
    @filterrific = initialize_filterrific(
      Book,
      params[:filterrific],
      :select_options => {
        with_category_id: Category.options_for_select
      }
    ) or return
  end
end