function chatController(postId) {
  var chatDAO = new ChatDAO(postId);
  
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
    var messages = [];
    chatsInfo.chats.forEach(function(chat) {
      var message = new Message(chat, membersMap[chat.user.id]);
      messages.push(message);
    });
    chat.addMessages(messages);
  });

}



jQuery(document).ready(function() {
	var t = location.pathname.substr(location.pathname.indexOf("/posts/") + 7);
  window.currentPostId = t.substr(0, t.indexOf("-"));
  chatController(currentPostId);

});