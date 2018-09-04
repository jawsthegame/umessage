module ChatsHelper
  CONTACTS = Contacts.new

  def name_from_number(identifier)
    if identifier == "Me"
      "Me"
    elsif identifier.is_a?(Array)
      identifier.map { |i| name_from_number(i) }.uniq.join(", ")
    elsif name = CONTACTS.by_phone(identifier)
      name
    else
      identifier
    end
  end
end
