class ChatsController < ApplicationController
  before_action :set_chat, only: :show

  def index
    @chats = Chat.all
  end

  def show
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_params
    params.fetch(:chat, {})
  end
end
