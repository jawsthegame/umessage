class MessagesController < ApplicationController
  def create
    Sender.send(
      params[:message][:conversation_id],
      params[:message][:text],
    )

    head :ok
  end

  private

  def message_params
    params.fetch(:message, %i[chat_id conversation_id text])
  end
end
