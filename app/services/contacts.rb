class Contacts
  CONTACTS = File.read("#{Rails.root}/db/contacts.txt")
  NON_DIGITS = /[^\d]/

  def initialize
    @contacts = Hash.new { nil }

    CONTACTS.strip.split("\n\n").each do |contact|
      contact = contact.split("\n")
      contact = contact.map do |line|
        _, k, v = */\A([^:]+): (.+)/.match(line)
        [k, v]
      end.to_h

      name = contact.slice(*%w[givenName familyName]).values.join(" ")
      next if name&.strip.blank?

      numbers =
        begin
          contact["phoneNumbers"].split(":").map do |n|
            n.gsub(NON_DIGITS, "")
          end.reject(&:blank?)
        rescue
          next
        end

      numbers.each do |n|
        next if n.strip.blank?
        @contacts[n.gsub(NON_DIGITS, "")] = name.strip
      end
    end
  end

  def by_phone(phone)
    digits = phone.gsub(NON_DIGITS, "")
    less_digits = digits[1..-1]
    @contacts[digits] || @contacts[less_digits]
  end
end
