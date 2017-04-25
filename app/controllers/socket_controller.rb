class SocketController < WebsocketRails::BaseController
  def client_joined_party
    broadcast_message :client_joined_party, message
  end

  def client_disconnected
    # todo: remove party from current_user
    broadcast_message :client_left_party, {user_name: current_user.nickname}
  end
end
