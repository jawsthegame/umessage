class ChatsChannel < ApplicationCable::Channel
  STREAM = "chat-updates"

  def subscribed
    stream_from STREAM
  end
end
