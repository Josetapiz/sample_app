// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .
$('.dropdown-toggle').dropdown()

function updateCountdown() {
    // 140 is the max message length
    var remaining = 140 - jQuery('.message').val().length;
    jQuery('.countdown').text(remaining + '/140');
    if (remaining < 0) {
    	$('.thisD').css("color", "red");
    	$('.lolo').removeClass('btn-primary').addClass('disabled');
    } else {
    	$('.thisD').css("color", "black");
    	$('.lolo').removeClass('disabled').addClass('btn-primary');
    }
}

jQuery(document).ready(function($) {
    updateCountdown();
    $('.message').change(updateCountdown);
    $('.message').keyup(updateCountdown);
});

$(document).ready(function(){
  $('.dropdown-menu form').on('click', function (e) {
    e.stopPropagation()
  });
});