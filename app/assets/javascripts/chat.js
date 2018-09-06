$(function() {
  adjustChatHeight();
  scrollChatToBottom();

  App.chats = App.cable.subscriptions.create("ChatsChannel", {
    connected: function() {
      $("[data-chat]").each(function(_, el) {
        this.follow($(el).data("chat"));
      }.bind(this));
    },

    follow: function(id) {
      this.perform("follow", { id: id });
    },

    received: function(data) {
      var chat = $(`[data-chat=${data.chat_id}]`);
      chat.find("tbody").append(data.chat_view);
      scrollChatToBottom();
    },
  });

  document.body.addEventListener("ajax:success", function(ev) {
    $(ev.srcElement).find("textarea").val("");
  });
});

function adjustChatHeight() {
  var bed = $("#bed")
  var chat_header = $("#chat h1");
  var chat = $("#chat .scroll");
  var message_form = $("#message-form");

  chat.css(
    "max-height",
    (
      parseInt(bed.css("height")) -
      parseInt(chat_header.css("height")) -
      parseInt(message_form.css("height"))
    )
  )
}

function scrollChatToBottom() {
  var chat = $("#chat .scroll");
  chat.scrollTop(chat.prop("scrollHeight"));
}

$("body").on("resize", adjustChatHeight);
