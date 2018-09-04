module ChatsHelper
  CONTACTS = Contacts.new

  def name_from_number(identifier)
    if identifier == "Me"
      "Me"
    elsif identifier.is_a?(Array)
      identifier.map { |i| name_from_number(i) }.uniq.join(", ")
    elsif c = CONTACTS.by_phone(identifier)
      name = [c["First"], c["Last"]].join(" ")
      nick = c["Nickname"]

      [name, nick, "Unknown"].reject(&:blank?).first
    else
      identifier
    end
  end
end
