class TaskController < WebsocketRails::BaseController
  def create
    send_message :create_success, {:message => 'this is a message'}, :namespace => "chats"
  end
end