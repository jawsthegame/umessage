$(function() {
  adjustChatHeight();
  scrollChatToBottom();
  sortConversations();

  App.following = [];

  App.chats = App.cable.subscriptions.create("ChatsChannel", {
    connected: function() {
      $("[data-chat]").each(function(_, el) {
        this.follow($(el).data("chat"));
      }.bind(this));
    },

    follow: function(id) {
      if (App.following.indexOf(id) == -1) {
        this.perform("follow", { id: id });
        App.following.push(id);
      }
    },

    received: function(data) {
      $(`#chat [data-chat=${data.chat_id}]`).append(data.chat_view);
      scrollChatToBottom();

      $(`#conversations [data-chat=${data.chat_id}]`).remove();
      $("#conversations .list-group").append(data.conversation_view);
      sortConversations();
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

function sortConversations() {
  $("#conversations .list-group .list-group-item").sort(function(a, b) {
    return parseInt($(a).data("date")) > parseInt($(b).data("date")) ? -1 : 1;
  }).appendTo("#conversations .list-group");
}

$("body").on("resize", adjustChatHeight);
