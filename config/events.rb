WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  #   subscribe :client_connected, :to => Controller, :with_method => :method_name
  #
  # Here is an example of mapping namespaced events:
  # namespace :party do
  #   subscribe :create, :to => PartiesController, :with_method => :create
  # end
  # The above will handle an event triggered on the client like `product.new`.
  # subscribe :join, 'socket#join'
  # subscribe :client_disconnected, 'socket#leave'
  # subscribe :user_left, 'socket#leave'

  subscribe :client_disconnected, 'socket#client_disconnected'
  subscribe :client_joined_party, 'socket#client_joined_party'
  subscribe :client_changed_name, 'socket#client_changed_name'
  subscribe :song_added, 'socket#song_added'
  subscribe :song_voted, 'socket#song_voted'

  # subscribe :connection_closed, 'socket#client_disconnected'

  # subscribe :connection_closed, 'socket#leave'
end
