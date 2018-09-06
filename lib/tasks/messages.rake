namespace :messages do
  task :setup do
    `mkdir public/images`
    `ln -s ~/Library/Messages/Attachments public/images/message_attachments`
  end

  task poll: :environment do
    ActiveRecord::Base.logger.silence do
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
              next if chat.nil?

              chat_view =
                messages.map do |message|
                  ApplicationController.render(message)
                end

              if messages.any?(&:is_from_me?)
                chat.reset_unread_count!
              else
                chat.increment_unread_count!(messages.reject(&:is_from_me?).size)
              end

              chat.define_singleton_method(:last_msg_at) { messages.last.sent_at }
              chat.define_singleton_method(:last_text) { messages.last.text }

              conversation_view = ApplicationController.render(
                partial: "chats/chat",
                locals: { chat: chat },
              )

              ChatsChannel.broadcast_to(
                chat,
                chat_id: chat.id,
                messages: messages,
                chat_view: chat_view,
                conversation_view: conversation_view,
              )
            end
          end
        rescue Exception => e
          logger.warn e.inspect
          logger.warn e.message
          logger.warn e.backtrace
        end

        sleep 1
      end
    end
  end
end
