require "csv"

class Contacts
  CONTACTS_CMD = "contacts -HSlf '%n:%hp:%wp:%mp:%Mp:%pp:%fp:%op'"
  NON_DIGITS = /[^\d]/

  def initialize(csv: "db/contacts.csv")
    @contacts = Hash.new { nil }

    `#{CONTACTS_CMD}`.each_line do |line|
      name, *numbers = *line.split(":")

      next if name.strip.blank?

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
