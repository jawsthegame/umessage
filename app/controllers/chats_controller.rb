class ChatsController < ApplicationController
  before_action :set_chat, only: :show

  def index
    @chat = Message.last.chats.first
    @chat.reset_unread_count!
    render :show
  end

  def show
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
    @chat.reset_unread_count!
  end
end
