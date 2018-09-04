require "csv"

class Contacts
  def initialize(csv: "db/contacts.csv")
    raw = CSV.read(csv, encoding: "utf-16le")
    headers = raw.first

    @contacts = raw[1..-1].map do |row|
      Hash.new.tap do |row_hash|
        headers.each.with_index { |h, hi| row_hash[h] = row[hi] }
      end
    end

    @lookup_cache = {}
  end

  NON_DIGITS = /[^\d]/
  PHONE_HEADERS = "
    Home
    old
    Main
    Other
    Mobile 1
    Mobile 2
    Work
    iPhone
    Home 1
    Home 2
    Work 1
    Work 2
    Work 3
    Work 4
  ".split("\n").map(&:strip).reject(&:blank?)

  def [](i)
    @contacts[i]
  end

  def by_phone(phone)
    return @lookup_cache[phone] if @lookup_cache.key?(phone)

    digits = phone.gsub(NON_DIGITS, "")
    less_digits = digits[1..-1]

    @lookup_cache[phone] = @contacts.find do |c|
      with_country_code = PHONE_HEADERS.any? do |h|
        c[h]&.gsub(NON_DIGITS, "") == digits
      end

      with_country_code || PHONE_HEADERS.any? do |h|
        c[h]&.gsub(NON_DIGITS, "") == less_digits
      end
    end
  end
end
