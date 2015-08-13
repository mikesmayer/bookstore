$ ->
  notice = $('#notice').text()
  Materialize.toast("#{notice}", 4000) unless notice.length < 20