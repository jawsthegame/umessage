$(function() {
  var chat = document.getElementById("chat");
  chat.scrollTop = chat.scrollHeight;

  App.chats = App.cable.subscriptions.create("ChatsChannel", {
    connected: function() {
      $("[data-chat]").each(function(i, el) {
        this.follow($(el).data("chat"));
      }.bind(this));
    },

    follow: function(id) {
      this.perform("follow", { id: id });
    },

    received: function(data) {
      var chat = $(`[data-chat=${data.chat_id}]`);
      chat.find("tbody").append(data.chat_view);
      chat.scrollTop(chat.prop("scrollHeight"));
    },
  });

  document.body.addEventListener("ajax:success", function(ev) {
    $(ev.srcElement).find("textarea").val("");
  });
});
