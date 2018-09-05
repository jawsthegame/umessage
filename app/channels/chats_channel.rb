class ChatsChannel < ApplicationCable::Channel
  def follow(data)
    stream_for Chat.find(data["id"])
  end
end
