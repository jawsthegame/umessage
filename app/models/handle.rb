# == Schema Information
#
# Table name: handle
#
#  ROWID              :integer          primary key
#  id                 :text             not null
#  country            :text
#  service            :text             not null
#  uncanonicalized_id :text
#

class Handle < ApplicationRecord
  self.table_name = 'handle'

  default_scope { select("*, id AS chat_identifier") }

  has_many :chat_handles
  has_many :chats, through: :chat_handles

  def self.select_identifier
    select("id AS identifier")
  end
end
