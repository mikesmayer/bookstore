$ ->
  notice = $('#notice').text()
  toast = Materialize.toast("#{notice}", 4000) unless notice.length < 20