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
//= require bootstrap-sprockets
//= require websocket_rails/main
var $ = jQuery;
jQuery( function($) {
  $("[data-placement]").tooltip()
});

var dispatcher = new WebSocketRails('localhost:3000/websocket');
var user_name = $('#user_name').text();

$(document).ready(function() {
  jQuery.bootstrapGrowl(`Welcome, ${user_name}`, { type: 'info' });
});

dispatcher.on_open = function(data) {
  console.info('Connection has been established: ', data);
  var message = {
    party_id: location.pathname.split('/')[2],
    user_name: user_name
  }

  dispatcher.trigger('join', message);
}

dispatcher.bind('join', function(data) {
  console.log("FOOOOOBAR");
  console.log(data);
  jQuery.bootstrapGrowl(`${data.user_name} has joined the party.`, { type: 'info' });
});
