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
//= require bootstrap-notify
//= require turbograft

// UTILITIES
var hyphenate = function(str) {
  return str.replace(/\s+/g, '-');
}

$(document).on('ready', function(event) {
  jQuery(function($) {
    var user_name = $('#user_name').text();
    $.bootstrapGrowl("Welcome," + user_name, { type: 'info' });
  });
});

// DONE ON RELOAD FROM SERVER
$(document).on('ready page:load', function(event) {
  jQuery(function($) {
    $("[data-placement]").tooltip()

    $.notifyDefaults({
      type: 'success',
      placement: {
        from: "bottom"
      },
      animate:{
        enter: "animated fadeInUp",
        exit: 'animated fadeOutRight'
      }
    });
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
        var message = {
          party_id: location.pathname.split('/')[2],
          old_name: oldNick,
          new_name: newNick
        };
        dispatcher.trigger('client_changed_name', message);
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
        console.log('SUCCESS!');
        var name = $('#user_name').text();
        var message = {
          party_id: location.pathname.split('/')[2],
          name: name
        };
        dispatcher.trigger('song_added', message);
      },
      error: function (jqXHR, textStatus, errorThrown) {
        console.log('FAILURE!'); // need better error handling
        console.log(textStatus, errorThrown);
      }
    });
  });

  $('.glyphicon-thumbs-up').on('click', function(event) {
    event.preventDefault();
    var songID = $(event.target).attr('data-song-id');
    var partyID = location.pathname.split('/')[2];

    $.ajax({
      url: "/parties/" + partyID + "/songs/" + songID + "/upvote",
      type: 'POST',
      success: function (data, textStatus, jqXHR) {
        dispatcher.trigger('song_voted');
      },
      error: function (jqXHR, textStatus, errorThrown) {
        console.error(textStatus, errorThrown);
      }
    });
  });

  $('.glyphicon-thumbs-down').on('click', function(event) {
    event.preventDefault();
    var songID = $(event.target).attr('data-song-id');
    var partyID = location.pathname.split('/')[2];

    console.log(songID);
    $.ajax({
      url: "/parties/" + partyID + "/songs/" + songID + "/downvote",
      type: 'POST',
      success: function (data, textStatus, jqXHR) {
        dispatcher.trigger('song_voted');
      },
      error: function (jqXHR, textStatus, errorThrown) {
        console.log(textStatus, errorThrown);
      }
    });
  });


});

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
  dispatcher.trigger('client_joined_party', message);
}

dispatcher.bind('client_joined_party', function(data) {
  Page.refresh({url: document.location, onlyKeys: ['user-list']});
  if (data.user_name != $('#user_name').text()) {
    console.log(data.user_name + "has joined the party.");
  }
});

dispatcher.bind('client_left_party', function(data) {
  if (data.user_name != $(document.location, '#user_name').text()) {
    // Turbolinks.visit(document.location, [change: 'user-list'])
    console.log(data.user_name + "has left the party.");
    jQuery.bootstrapGrowl(data.user_name + "has left the party.", { type: 'info' });
  }
});

dispatcher.bind('client_changed_name', function(data) {
  // Turbolinks.visit(document.location, [change: 'user-list'])
  Page.refresh({url: document.location, onlyKeys: ['user-playlist']});

  $.bootstrapGrowl(
    data.old_name + "has changed their nickname to" + data.new_name,
    { type: 'info' }
  );
});

dispatcher.bind('song_added', function(data) {
  Page.refresh({url: document.location, onlyKeys: ['party-playlist']});

  $.bootstrapGrowl(
    data.name + "added a song.",
    { type: 'info' }
  );
});

dispatcher.bind('song_voted', function(data) {
  Page.refresh({url: document.location, onlyKeys: ['party-playlist']});
});
