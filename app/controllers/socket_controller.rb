class SocketController < WebsocketRails::BaseController
  def join
    p 'F I R E D H E L L O  O O O O O O O O'
    p message
    broadcast_message :join, message
  end

  def goodbye
    Viewer.decrement_counter(:count, 1)
    @count = Viewer.first.count
    WebsocketRails[:updates].trigger(:update, @count)
  end
end
