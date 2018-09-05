# == Schema Information
#
# Table name: chat
#
#  ROWID                 :integer          primary key
#  guid                  :text             not null
#  style                 :integer
#  state                 :integer
#  account_id            :text
#  properties            :binary
#  chat_identifier       :text
#  service_name          :text
#  room_name             :text
#  account_login         :text
#  is_archived           :integer          default(0)
#  last_addressed_handle :text
#  display_name          :text
#  group_id              :text
#  is_filtered           :integer          default(0)
#  successful_query      :integer          default(1)
#

class Chat < ApplicationRecord
  self.table_name = 'chat'

  has_many :chat_messages
  has_many :messages, through: :chat_messages

  has_many :chat_handles
  has_many :handles, through: :chat_handles

  def sanitized_guid
    guid.sub(/\w+;.;/, '')
  end

  def self.fuzzy_search(params)
    results = []
    params.each { |param| results << "guid LIKE '%#{param}%'" }
    joined_results = results.join(' OR ')
    where(joined_results).pluck(:ROWID)
  end

  def identifiers
    if chat_identifier && chat_identifier[0..3] == "chat"
      handle_ids = messages.select("DISTINCT(handle_id) AS handle_id").map(&:handle_id)

      Handle.where("ROWID IN (?)", handle_ids)
        .select("id AS identifier")
        .map(&:identifier)
    else
      chat_identifier
    end
  end
end
