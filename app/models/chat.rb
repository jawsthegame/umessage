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

  class << self
    def for_conversations
      select(
        <<~SQL
          chat.ROWID,
          (
            SELECT datetime(
              message.date / 1000000000 + strftime("%s", "2001-01-01"),
              "unixepoch", "localtime"
            ) AS date_utc
            FROM message
            JOIN chat_message_join ON chat_message_join.message_id = message.ROWID
            WHERE chat_message_join.chat_id = chat.ROWID
            ORDER BY date DESC
            LIMIT 1
          ) AS last_msg_at,
          (
            SELECT text
            FROM message
            JOIN chat_message_join ON chat_message_join.message_id = message.ROWID
            WHERE chat_message_join.chat_id = chat.ROWID
            ORDER BY date DESC
            LIMIT 1
          ) AS last_text
        SQL
      )
        .includes(:handles)
    end

    def fuzzy_search(params)
      results = []
      params.each { |param| results << "guid LIKE '%#{param}%'" }
      joined_results = results.join(' OR ')
      where(joined_results).pluck(:ROWID)
    end
  end

  def sanitized_guid
    guid.sub(/\w+;.;/, '')
  end

  def identifiers
    handles.map(&:chat_identifier)
  end

  def unread_count
    @unread_count ||= redis.get("chat:#{id}:unread")&.to_i || 0
  end

  def unread_count=(count)
    redis.set("chat:#{id}:unread", count)
    @unread_count = count
  end

  def increment_unread_count!(by = 1)
    @unread_count = redis.incrby("chat:#{id}:unread", by).to_i
  end

  def reset_unread_count!
    redis.set("chat:#{id}:unread", 0)
    @unread_count = 0
  end
end
