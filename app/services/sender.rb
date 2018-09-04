class Sender
  def self.send(chat_id, message, attachment_path = nil)
    if attachment_path.nil?
      osascript <<~OSA
        tell application "Messages"
          set chat_id to #{chat_id.inspect}
          set message to #{message.inspect}
          set conversation to a reference to text chat id chat_id
          send message to conversation
        end tell
      OSA
    end
  end

  private

  def self.osascript(script)
    system 'osascript', *script.split(/\n/).map { |line| ['-e', line] }.flatten
  end
end
