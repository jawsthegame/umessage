Thread.new do
  logger = 
    if ENV["DEBUG_CHAT_POLL"]
      Logger.new("log/chat_poll.log")
    else
      Logger.new("/dev/null")
    end

  last_message = Message.order("ROWID DESC")
    .limit(1).pluck(:ROWID).first

  loop do
    begin
      logger.info "POLLING FROM #{last_message}"

      new_messages = Message.for_chat
        .where("message.ROWID > ?", last_message)
        .order("message.ROWID")

      if new_messages.any?
        logger.info "BROADCASTING NEW MESSAGES"
        last_message = new_messages.last.id

        new_messages.group_by { |m| m.chats.first }.each do |chat, messages|
          chat_view =
            messages.map do |message|
              ApplicationController.render(message)
            end

          ChatsChannel.broadcast_to(
            chat,
            chat_id: chat.id,
            messages: messages,
            chat_view: chat_view,
          )
        end
      end
    rescue Exception => e
      logger.warn e.inspect
      logger.warn e.message
    end

    sleep 1
  end
end
