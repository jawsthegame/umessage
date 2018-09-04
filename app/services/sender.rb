class Sender
  def self.send(chat_id, message, attachment_path = nil)
    _, service, _group, phone =
      */\A(SMS|iMessage);(-|\+);\+?((chat)?\d+)\Z/.match(chat_id)

    if /\Achat\d+\Z/.match?(phone)
      # Group chats
      puts "Sending to group #{phone}..."
      osascript <<~OSA
        tell application "Messages"
          set chat_id to #{chat_id.inspect}
          set message to #{message.inspect}
          set conversation to a reference to text chat id chat_id
          send message to conversation
        end tell
      OSA

    elsif service == "iMessage"
      # For individual iMessage conversations
      puts "Sending iMessage to #{phone}..."
      osascript <<~OSA
        tell application "Messages"
          set message to #{message.inspect}
          set msg_service to 1st service whose service type = iMessage
          set my_buddy to buddy #{phone.inspect} of msg_service
          send message to my_buddy
        end tell
      OSA

    elsif service == "SMS"
      # Slightly different approach needed for SMS
      puts "Sending SMS to #{phone}..."
      osascript <<~OSA
        tell application "Messages"
          set message to #{message.inspect}
          set my_buddy to buddy #{phone.inspect} of service "SMS"
          send message to my_buddy
        end tell
      OSA

    else
      raise "Unrecognized service #{service.inspect}!"
    end
  end

  private

  def self.osascript(script)
    system 'osascript', *script.split(/\n/).map { |line| ['-e', line] }.flatten
  end
end
