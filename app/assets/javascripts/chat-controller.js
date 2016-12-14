function chatController(postId) {
  var chatDAO = new ChatDAO(postId);
  var lastChatId;
  chatDAO.getChatsInfo({limit: 20}, function(chatsInfo) {
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
        callback(error, data);
      });
    });
    
    if (chatsInfo.chats.length > 0) {
      lastChatId = chatsInfo.chats[chatsInfo.chats.length - 1].id;
    }
    chat.addMessages(getMessagesFromChatInfo(chatsInfo));
    $('.js_upload_form').on("ajax:remotipartComplete", function(e, data) {
      console.log('adsaasd', e, data);
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

    function fetchLattestMessages(lastChatId) {
      chatDAO.getChatsInfo({after_id: lastChatId}, function(ci) {
        if (ci.chats.length > 0) {
          lastChatId = ci.chats[ci.chats.length - 1].id; // move this to a function
        }
        var messages = getMessagesFromChatInfo(ci, true);
        chat.addMessages(messages);
        chat.addUsersToUserArea(getUsersFromChatInfo(ci));

      });
    }

  });

  
}
