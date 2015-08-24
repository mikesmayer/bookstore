$ ->
  $('.order-quantity').on 'change', ->
    price    = $(this).closest('tr').find('.book-price:first').text().replace(/[$]/, '');
    quantity = $(this).val()
    price    = parseFloat(price)
    quantity = parseInt(quantity)
    total_price = parseFloat(price) * quantity
    $(this).closest('tr').find('.total-price:first').text("$" + total_price)
    $('#books_price').text('Books Price:  $' + total_price)
    sale = $('#sale').text()
    sale = parseFloat(sale)
    sale = sale*total_price
    $('#books_sale').text('Sale:  -$' + sale)
    $('#subtotal_price').text('SUBTOTAL: $' + "#{total_price - sale}")

    # alert sale