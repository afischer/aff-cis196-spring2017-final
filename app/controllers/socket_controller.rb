class SocketController < WebsocketRails::BaseController
  def client_joined_party
    broadcast_message :client_joined_party, message
  end

  def client_disconnected
    # TODO: remove party from current_user
    broadcast_message :client_left_party, user_name: current_user.nickname
  end

  def client_changed_name
    broadcast_message :client_changed_name, message
  end

  def song_added
    broadcast_message :song_added, message
  end
end
