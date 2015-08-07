module OrderStepsHelper
  def errors(resource, nested_recource = nil, field)
    if resource.errors.messages.empty?
      nil
    elsif nested_recource.nil?
    else
      resource.errors["#{nested_recource}.#{field}".to_sym].first
    end
  end

  def check_delivery(order_delivery_id, delivery_id)
    if order_delivery_id != nil
     'checked' if order_delivery_id == delivery_id
    else
     'checked' if Delivery.find(delivery_id) == Delivery.last
    end
  end

  def month_collection
    month_collection = []
    (1..12).each{|m| month_collection << [m]}
    month_collection
  end

  def year_collection
    year_collection = []
    (2015..2020).each{|y| year_collection << [y]}
    year_collection
  end

  def date_errors(resource, nested_recource = nil, field)
    if resource.errors.messages.empty?
      nil
    elsif nested_recource.nil?
    else
      resource.errors["#{nested_recource}.#{field}".to_sym]
    end
  end
end
