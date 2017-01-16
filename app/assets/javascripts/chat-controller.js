function chatController(postId) {
  if (!Notification) {
    alert('Desktop notifications not available in your browser. Try Chromium.'); 
    return;
  }
  if (Notification.permission !== "granted") {
    Notification.requestPermission().then(function(permission) { 
       
    });;
  }
  var chatDAO = new ChatDAO(postId);
  var lastChatId;
  var firstChatId;
  var isScrollingUp;
  var isWindowActive = true;
  $(window).blur(function(){
    isWindowActive = false;
  });
  $(window).focus(function(){
    isWindowActive = true;
  });
  chatDAO.getChatsInfo({limit: 30}, function(chatsInfo) {
    var members = [];
    var membersMap = {};
    chatsInfo.members.forEach(function(m) {
      var user = new User(m);
      members.push(user);
      membersMap[user.id] = user;
    });
    
    var chat = new Chat(new User(current_user), members, {}, function(message, callback) {
      myMessageSent = true;
      chatDAO.sendMessage(message, function(error, data) {
        if (callback) {
          callback(error, data);
        }
      });
    });
    
    if (chatsInfo.chats.length > 0) {
      lastChatId = chatsInfo.chats[chatsInfo.chats.length - 1].id;
      firstChatId = chatsInfo.chats[0].id; // handle case when no messages.
    }

    chat.setScrollTopEventCallback(function() {
      if (!isScrollingUp) {
        isScrollingUp = true;
        chatDAO.getChatsInfo({before_id: firstChatId, limit: 10}, function(ci) {
          if (ci.chats.length > 0) {
            firstChatId = ci.chats[0].id; // move this to a function
          }
          var messages = getMessagesFromChatInfo(ci);
          chat.addMessagesToTop(messages);
          isScrollingUp = false;
        });
      }
    });
    chat.addMessages(getMessagesFromChatInfo(chatsInfo));
    $('.js_upload_form').on("ajax:remotipartComplete", function(e, data) {
      var c = JSON.parse(data.responseText).chat;
      var msg = new Message(c, membersMap[c.user.id]);
      chat.addMessage(msg);
    });

    setInterval(function() {
      fetchLattestMessages(lastChatId);
    }, 5000);
    
    function getMessagesFromChatInfo(chatsInfo, excludeMyMessages) {
      var messages = [];
      chatsInfo.chats.forEach(function(chat) {
        if (!(excludeMyMessages && chat.user.id == current_user.id)) {
          var message = new Message(chat, membersMap[chat.user.id]);
          messages.push(message);  
        } // TODO this will not work if multiple windows are open FIX
      });
      return messages;
    }

    function getUsersFromChatInfo(chatsInfo) {
      var members = [];
      chatsInfo.members.forEach(function(m) {
        var user = new User(m);
        members.push(user);
      });
      return members;
    }

    function fetchLattestMessages() {
      chatDAO.getChatsInfo({after_id: lastChatId}, function(ci) {
        if (ci.chats.length > 0) {
          lastChatId = ci.chats[ci.chats.length - 1].id; // move this to a function
        }
        var messages = getMessagesFromChatInfo(ci, true);
        chat.addMessages(messages);
        chat.addUsersToUserArea(getUsersFromChatInfo(ci));
        desktopNotification(messages);
      });
    }

  });

  function desktopNotification(messages) {
    if (!isWindowActive) {
      if (Notification.permission !== "granted") {
        Notification.requestPermission();
      } else {
        messages.forEach(function(message) {
          var notification = new Notification('New message from ' + message.user.name, {
            icon: message.user.picture,
            body: message.text
            //sound: path //TODO
          });

          notification.onclick = function () {
            window.focus(); 
            //window.open("http://stackoverflow.com/a/13328397/1269037");      
          };
        });
      }  
    }
  }  

}


