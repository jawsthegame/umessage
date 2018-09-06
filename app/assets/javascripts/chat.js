$(function() {
  Notification.requestPermission();

  adjustChatHeight();
  scrollChatToBottom();
  sortConversations();

  $("img").one("load", function() {
    scrollChatToBottom();
  }).each(function() {
    try { if(this.complete) $(this).load(); } catch {}
  });

  App.chats = App.cable.subscriptions.create("ChatsChannel", {
    received: function(data) {
      var chat = $(`#chat [data-chat=${data.chat_id}]`)

      if (chat.length > 0) {
        chat.append(data.chat_view);
        scrollChatToBottom();
      }

      for (var i in data.messages) {
        var message = data.messages[i];
        if (message.is_from_me != 1) {
          var notification = new Notification("uMessage", {
            body: `${message.identifier}: ${message.text}`
          });
        }
      }

      $(`#conversations [data-chat=${data.chat_id}]`).remove();
      $("#conversations .list-group").append(data.conversation_view);
      sortConversations();
    },
  });

  document.body.addEventListener("ajax:success", function(ev) {
    $("#message-form textarea").val("");
    $("#message-form .custom-file-input").val("");
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

  chat_id = $("#chat [data-chat]").data("chat");
  conversation = $(`#conversations [data-chat=${chat_id}]`);
  conversation.addClass("active");
  conversation.find(".badge").remove();
}

$("body").on("resize", adjustChatHeight);
