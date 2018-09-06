class Sender
  def self.send(chat_id, message, attachment_path = nil)
    _, service, _group, phone =
      */\A(SMS|iMessage);(-|\+);\+?((chat)?\d+)\Z/.match(chat_id)

    set_attachment, send_attachment = nil, nil

    if attachment_path.present?
      ext = /\.(.+)\Z/.match(attachment_path)
      new_path = "#{Rails.root}/tmp/#{Time.now.to_i}.#{ext}"

      `cp #{attachment_path} #{new_path.inspect}`

      set_attachment = <<~OSA
        tell application "System Events"
          set the_attachment to POSIX file #{new_path.inspect}
        end tell
      OSA

      send_attachment = <<~OSA
        send the_attachment to conversation
      OSA
    end

    if /\Achat\d+\Z/.match?(phone)
      # Group chats
      puts "Sending to group #{phone}..."
      osascript <<~OSA
        #{set_attachment ? set_attachment : ""}

        tell application "Messages"
          set chat_id to #{chat_id.inspect}
          set message to #{message.inspect}
          set conversation to a reference to text chat id chat_id
          #{send_attachment ? send_attachment : ""}
          send message to conversation
        end tell
      OSA

    elsif service == "iMessage"
      # For individual iMessage conversations
      puts "Sending iMessage to #{phone}..."
      osascript <<~OSA
        #{set_attachment ? set_attachment : ""}

        tell application "Messages"
          set message to #{message.inspect}
          set msg_service to 1st service whose service type = iMessage
          set conversation to buddy #{phone.inspect} of msg_service
          #{send_attachment ? send_attachment : ""}
          send message to conversation
        end tell
      OSA

    elsif service == "SMS"
      # Slightly different approach needed for SMS
      puts "Sending SMS to #{phone}..."
      osascript <<~OSA
        #{set_attachment ? set_attachment : ""}

        tell application "Messages"
          set message to #{message.inspect}
          set conversation to buddy #{phone.inspect} of service "SMS"
          #{send_attachment ? send_attachment : ""}
          send message to conversation
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
