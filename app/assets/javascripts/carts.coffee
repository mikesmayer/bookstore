$ ->
  $('.order-quantity').on 'change', ->
    price    = $(this).closest('tr').find('.book-price:first').text().substr(1);
    quantity = $(this).val()
    price    = parseFloat(price)
    quantity = parseInt(quantity)
    total_price = parseFloat(price) * quantity
    $(this).closest('tr').find('.total-price:first').text("$" + total_price)

    #alert price