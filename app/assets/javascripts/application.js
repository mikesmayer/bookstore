// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery.turbolinks
//= require materialize-sprockets
//= require filterrific/filterrific-jquery
//= require_tree .

// $( document ).ready(function() {
//     $("form").on("keypress", function (e) {
//     if (e.keyCode == 13) {
//         return false;
//     }
// });
// });

$(document).ready(function() {

    $('select').material_select();
    $('#search-panel').pushpin({ top: 150 });
    $('.cart').pushpin({ top: 150});
    // $('select.rating').material_select('destroy');
    // $('select#book_category_id').select2();
    // $('select#book_author_id').select2();

});

