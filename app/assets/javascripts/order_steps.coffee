$ ->
    checkboxId     = $('input[type="radio"]:checked').attr('id')
    labelText      = $("label[for= #{checkboxId}]").text()
    deliveryPrice  = labelText.split("$").pop();
    deliveryPrice  = parseFloat(deliveryPrice)
    itemsPriceText = $("#item_price").text()
    itemsPrice     = itemsPriceText.split("$").pop()
    itemsPrice     = parseFloat(itemsPrice)
    totalPrice     = itemsPrice + deliveryPrice
    $("#delivery_price").text("SHIPPING: $ " + "#{deliveryPrice}")
    $("#total_price").text("ORDER TOTAL: $ " + "#{totalPrice}")

$ ->
  $('input[type="radio"]').on 'click', ->
    checkboxId     = $(this).attr('id')
    labelText      = $("label[for= #{checkboxId}]").text()
    deliveryPrice  = labelText.split("$").pop();
    deliveryPrice  = parseFloat(deliveryPrice)
    itemsPriceText = $("#item_price").text()
    itemsPrice     = itemsPriceText.split("$").pop()
    itemsPrice     = parseFloat(itemsPrice)
    totalPrice     = itemsPrice + deliveryPrice
    $("#delivery_price").text("SHIPPING: $ " + "#{deliveryPrice}")
    $("#total_price").text("ORDER TOTAL: $ " + "#{totalPrice}")

$ ->
  $('#billing_address_form').addClass('hide') if $("#billing_equal_shipping").attr('val') == 'true'
  $('#use_shipping_address').on 'change', ->
    $('#billing_address_form').toggleClass( "hide" )