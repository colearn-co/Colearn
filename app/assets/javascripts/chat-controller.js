function chatController(postId) {
  var chatDAO = new ChatDAO(postId);
  var lastChatId;
  
  chatDAO.getChatsInfo({limit: 250}, function(chatsInfo) {
    var members = [];
    var membersMap = {};
    chatsInfo.members.forEach(function(m) {
      var user = new User(m);
      members.push(user);
      membersMap[user.id] = user;
    });
    var chat = new Chat(new User(current_user), members, {}, function(message, callback) {
      chatDAO.sendMessage(message, callback);
    });
   
    if (chatsInfo.chats.length > 0) {
      lastChatId = chatsInfo.chats[chatsInfo.chats.length - 1].id;
    }
    chat.addMessages(getMessagesFromChatInfo(chatsInfo));
    setInterval(function() {
      chatDAO.getChatsInfo({after_id: lastChatId}, function(ci) {
        var messages = getMessagesFromChatInfo(ci, true);
        chat.addMessages(messages);
        if (ci.chats.length > 0) {
          lastChatId = ci.chats[ci.chats.length - 1].id; // move this to a function
        }
      });
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

  });

  
}



jQuery(document).ready(function() {
	var t = location.pathname.substr(location.pathname.indexOf("/posts/") + 7);
  window.currentPostId = t.substr(0, t.indexOf("-")); // set this from server side probabaly?
  chatController(currentPostId);

  

});