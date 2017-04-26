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
//= require bootstrap-sprockets
//= require websocket_rails/main

// UTILITIES

console.log("LOAAAAD");

var hyphenate = function(str) {
  return str.replace(/\s+/g, '-');
}

// Globals?
// var ip;

// $.getJSON('//api.ipify.org?format=jsonp&callback=?', function(data) {
//   ip = data.ip;
// });
// console.log(ip);

/**
 * BOOTSTRAP
 * Enable tooltips, growl notifs on load.
 */
// Enable tooltips on load

$(document).ready(function() {
  jQuery(function($) {
    var user_name = $('#user_name').text();
    $.bootstrapGrowl(`Welcome, ${user_name}`, { type: 'info' });
  });
});

document.addEventListener("turbolinks:load", function() {
  jQuery(function($) {
    $("[data-placement]").tooltip()
  });


  var user_name = $('#user_name').text();

  $('#change-nickname').on('click', function(event) {
    event.preventDefault();
    var oldNick = $('#user_name').text();
    var newNick = $('#new-nickname').val();
    var userID = $('#new-nickname').attr('data-user-id');
    // Post to users
    $.ajax({
      url: '/users/' + userID, // TODO: Serverside check
      type: 'PATCH',
      data: {"user": {"nickname": newNick, "id": userID}, "source": "nav"},
      success: function (data, textStatus, jqXHR) {
        console.log('SUCCESS!');
        $('#nav-nickname-form').fadeOut(200, function() {
          $('#nav-greating').fadeIn(200);
        });
        // Dispatch event
        changeNickAndAnnounce(oldNick, newNick);
      },
      error: function (jqXHR, textStatus, errorThrown) {
        console.log('FAILURE!');
        console.log(textStatus, errorThrown);
      }
    });
  });

  $('#toggle-nick-edit').on('click', function(event) {
    event.preventDefault();
    $('#nav-greating').fadeOut(200, function() {
      $('#nav-nickname-form').fadeIn(200);
    });
  });

  // Song Addition and Removal
  $('#add-song').on('click', function(event) {
    event.preventDefault();
    var searchQuery = $('#song_title').val();
    var partyID = location.pathname.split('/')[2];
    // Post to users
    $.ajax({
      url: '/songs',
      type: 'POST',
      data: {"song": {"title": searchQuery, "party_id": partyID}, "source": "nav"},
      // TODO: serverside validation
      success: function (data, textStatus, jqXHR) {
        console.log(data);
        console.log('SUCCESS!');
        Turbolinks.visit(window.location);
        // Dispatch event
        // changeNickAndAnnounce(oldNick, newNick);
      },
      error: function (jqXHR, textStatus, errorThrown) {
        console.log('FAILURE!'); // need better error handling
        console.log(textStatus, errorThrown);
      }
    });
  });

});

// jquery add/remove people magic
var addUser = function(name) {
  jQuery.bootstrapGrowl(`${name} has joined the party.`, { type: 'info' });
  if (!($(`#user-list-${hyphenate(name)}`).length)) {
    $('#user-list').append(
      '<li id="user-list-' + hyphenate(name) + '" class="list-group-item">' +
        name +
      '</li>'
    );
  }
};

var removeUser = function(name) {
  jQuery.bootstrapGrowl(`${name} has left the party.`, { type: 'info' });
  $(`#${hyphenate(name)}`).remove()
};


/**
 *
 * INTERACTION
 *
 */

 // Navigation change nickname
var changeNickAndAnnounce = function(oldName, newName) {
  var message = {
    party_id: location.pathname.split('/')[2],
    old_name: oldName,
    new_name: newName
  };
  $('#user_name').text(newName);
  dispatcher.trigger('client_changed_name', message);
}



/**
 *
 * WEBSOCKETS
 *
 */
var dispatcher = new WebSocketRails('localhost:3000/websocket');
var channel_name = 'party';  // TODO: FIX THIS NAMESPACING
var channel = dispatcher.subscribe(channel_name);

dispatcher.on_open = function(data) {
  // TODO: don't allow multiple connections across tabs!!
  console.info('Connection has been established: ', data);
  var message = {
    party_id: location.pathname.split('/')[2],
    user_name: user_name
  }
}

dispatcher.bind('client_joined_party', function(data) {
  if (data.user_name != user_name) { // User joining is not you
    addUser(data.user_name);
    console.log('User joind:', data);
  }
});

dispatcher.bind('client_left_party', function(data) {
  if (data.user_name != user_name) {
    removeUser(data.user_name);
    console.log('User left', data);
  }
});

dispatcher.bind('client_changed_name', function(data) {
  Turbolinks.visit(window.location);

  $.bootstrapGrowl(
    `${data.old_name} has changed their nickname to ${data.new_name}.`,
    { type: 'info' }
  );
});
