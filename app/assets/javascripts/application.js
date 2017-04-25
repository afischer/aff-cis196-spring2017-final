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

// UTILITIES
var hyphenate = function(str) {
  return str.replace(/\s+/g, '-');
}

// Globals?
var user_name = $('#user_name').text();
var ip;

$.getJSON('//api.ipify.org?format=jsonp&callback=?', function(data) {
  ip = data.ip;
});
console.log(ip);

/**
 * BOOTSTRAP
 * Enable tooltips, growl notifs on load.
 */
// Enable tooltips on load
jQuery( function($) {
  $("[data-placement]").tooltip()
  $.bootstrapGrowl(`Welcome, ${user_name}`, { type: 'info' });
});

// jquery add/remove people magic
var addUser = function(name) {
  jQuery.bootstrapGrowl(`${name} has joined the party.`, { type: 'info' });
  $('#user-list').append(
    '<li id="' + hyphenate(name) + '" class="list-group-item">' +
      name +
    '</li>'
  );
};

var removeUser = function(name) {
  jQuery.bootstrapGrowl(`${name} has left the party.`, { type: 'info' });
  $(`#${hyphenate(name)}`).remove()
};

/**
 *
 * WEBSOCKETS
 *
 */
var dispatcher = new WebSocketRails('localhost:3000/websocket');
var channel_name = 'party';  // TODO: FIX THIS NAMESPACING
var channel = dispatcher.subscribe(channel_name);

dispatcher.on_open = function(data) {
  console.info('Connection has been established: ', data);
  var message = {
    party_id: location.pathname.split('/')[2],
    user_name: user_name
  }
  dispatcher.trigger('client_joined_party', message);
}

dispatcher.bind('client_joined_party', function(data) {
  if (data.user_name != user_name) { // User joining is not you
    addUser(data.user_name);
    console.log('User joind:', data);
  }
});

dispatcher.bind('client_left_party', function(data) {
  removeUser(data.user_name);
  console.log('User left', data);
});
