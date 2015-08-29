class CalculateBookQuantity
  include Service

  def initialize(params)
    @quantity = params[:quantity] unless params.nil?
    
  end

  def call
    unless @quantity
      1
    else
      @quantity.to_i
    end
  end
  
end
